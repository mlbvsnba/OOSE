from django import forms
from django.core.exceptions import ObjectDoesNotExist
from django.db import models
import django.contrib.auth.models
from django.forms import ModelForm
from pyapns import configure, provision, notify
import random
import hashlib
import base64


class CommonUser(django.contrib.auth.models.User):
    # Django's built-in common (non-developer) user.
    # This user can subscribe to lists and has a SubscriptionSettings object for each list it is subscribed to.
    # By using the django User base-class, we can have assured security with regards to user authentication.

    def register_device(self, device_token, commit=True):
        """
        Registers a device (given by it's APNS token) to the current CommonUser.
        :param device_token: the CommonUser's device's token given by APNS
        :type device_token: str
        :param commit: if true then the resulting IOSDevice object is commited/saved to the database
        :type commit: bool
        :return: the created IOSDevice
        :rtype: IOSDevice
        """
        device = self.iosdevice_set.create(token=device_token)
        if commit and device is not None:
            device.save()
        return device

    def create_personal_subscription(self):
        """
        Creates a CommonUser's personal subscription list.
        :return: None
        """
        Subscription.create_personal_sub(self)


class IOSDevice(models.Model):
    """
    Represents a single device owned by a CommonUser
    """
    user = models.ForeignKey(CommonUser)  # a many-to-one relationship
    token = models.CharField(max_length=64, blank=False, null=False)  # the device's APNS token


class CommonUserForm(ModelForm):
    """
    A form used for creating a new CommonUser.
    """

    class Meta:
        model = CommonUser
        fields = ['first_name', 'last_name', 'email', 'username', 'password']

    def save(self, commit=True):
        """
        Saves the forms data into a new CommonUser using the data provided.
        If commit is true, then this also calls teh create_personal_subscription method on the newly created
        CommonUser object.
        :param commit: if true then the newly created CommonUser object is commited/saved to the database
        :type commit: bool
        :return: the newly created CommonUser object
        :rtype: CommonUser
        """
        user = super(CommonUserForm, self).save(commit=commit)
        user.set_password(self.cleaned_data["password"])
        if commit:
            user.create_personal_subscription()
        if commit:
            user.save()
        return user


class SubscriptionSettings(models.Model):
    # A specific User's settings for a Subscription.

    user = models.ForeignKey('CommonUser')
    subscription = models.ForeignKey('Subscription')
    receive_notifications = models.BooleanField(default=True)
    radius_in_miles = models.IntegerField(default=-1)
    notification_frequency = models.IntegerField(default=-1)


class Developer(django.contrib.auth.models.User):
    # # A Developer who can create and push Notifications to Subscriptions that it creates.
    PERSONAL_USERNAME = 'PERSONAL_DEV'  # the name of the "fake" developer who "owns" Personal Subscription lists

    api_key = models.CharField(max_length=43, blank=False)  # a developer's api key

    @staticmethod
    def get_personal_dev():
        """
        Gets the "fake" developer instance who "owns" all Personal Subscription Lists - if one does not exist then it
        is created.
        :return: the Developer object which is guaranteed to be commited/saved before the object is returned
        :rtype: Developer
        """
        try:
            dev = Developer.objects.get(username=Developer.PERSONAL_USERNAME)
        except ObjectDoesNotExist:
            dev = Developer.objects.create(api_key=Developer.create_api_key(),
                                           username=Developer.PERSONAL_USERNAME)
            dev.set_password(Developer.PERSONAL_USERNAME)
            dev.save()
        return dev

    def verify_api_key(self, api_key):
        """
        Verifies a Developer's API key.
        :param api_key: string representation of the Developer's API key
        :type api_key: str
        :return: True if the api key matches that of the Developer
        :rtype: bool
        """
        assert isinstance(api_key, str)
        return self.api_key == api_key

    def create_subscription(self, name, description):
        """
        Creates a Subscription owned by this Developer.  This does NOT save/commit the Subscription object.
        :param name: the name of the subscription (length <= 50 chars)
        :type name: str
        :param description: the description of this Subscription (length <= 300 chars)
        :type description: str
        :return: the Subscription object
        :rtype: Subscription
        """
        sub = self.subscription_set.create(owner=self, name=name,
                                           description=description)
        return sub

    @staticmethod
    def create_api_key():
        """
        Creates a new API key which is sufficiently random enough for security purposes.
        NOTE: method adapted from http://jetfar.com/simple-api-key-generation-in-python/
        :return: a new api key
        :rtype: str
        """
        h = hashlib.sha256(str(random.getrandbits(256))).digest()
        rand = random.choice(['rA', 'aZ', 'gQ', 'hH', 'hG', 'aR', 'DD'])
        return base64.b64encode(h, rand).rstrip('==')


class DeveloperForm(ModelForm):
    """
    Form to create a developer account
    """

    class Meta:
        model = Developer
        fields = ['first_name', 'last_name', 'email', 'username', 'password']

    def save(self, commit=True):
        """
        Converts the form's data into an equal new Developer object.
        :param commit: if true then the Developer is commited/save to the database
        :type commit: bool
        :return: the Developer object
        :rtype: Developer
        """
        dev = super(DeveloperForm, self).save(commit=False)
        dev.set_password(self.cleaned_data["password"])
        if not dev.api_key:
            dev.api_key = Developer.create_api_key()
        if commit:
            dev.save()
        return dev


class Subscription(models.Model):
    """
    A Subscription list which is owned by a Developer and contains Users.
    """
    owner = models.ForeignKey(Developer, editable=False)
    name = models.CharField(max_length=50)
    description = models.CharField(max_length=300)
    creation_date = models.DateTimeField('date created', auto_now_add=True, editable=False)
    is_personal = models.BooleanField(default=False)
    user_id = models.IntegerField(null=True)

    def add_user(self, user, save=True):
        """
        Adds a user to this subscription's list of subscribers by creating a new SubscriptionSettings object.
        Note: This method will not create duplicates but will instead act as if it added it the first time.
        Thus it is safe to call multiple times.
        :param user: the CommonUser to add
        :type user: CommonUser
        :param save: if true then commits the
        :type save: bool
        :return: the SubscriptionSettings object mapping the user to this Subscription's subscriber list
        :rtype: SubscriptionSettings
        """
        if not isinstance(user, CommonUser):
            raise Exception('must be a CommonUser')
        settings = None
        try:
            settings = SubscriptionSettings.objects.get(
                subscription=self, user=user)
        except ObjectDoesNotExist:
            pass
        if settings is not None:
            return settings
        settings = self.subscriptionsettings_set.create(user=user,
                                                        subscription=self)
        if save and settings is not None:
            settings.save()
        return settings

    def create_notification(self, contents, url=""):
        """
        Creates and pushes a Notification to this Subscription given its contents and url.
        :param contents: the contents of the Notification.
        :type contents: str
        :param url: the URL for this Notification (optional)
        :type url: str
        :return: the DeveloperNotification
        :rtype: DeveloperNotification
        """
        notif = self.developernotification_set.create(sender=self.owner, contents=contents, url=url)
        notif.push()
        return notif

    @staticmethod
    def create_personal_sub(user):
        """
        Creates the personal subscription list for a given user.
        Note: This method should only be called once per CommonUser!
        :param user: the CommonUser to create the list for
        :type user: CommonUser
        :return: None
        """
        dev = Developer.get_personal_dev()
        name = "Personal Feed"
        description = user.first_name + "'s Personal Feed"
        sub = Subscription.objects.create(
            owner=dev, name=name, description=description, is_personal=True, user_id=user.id)
        sub.save()
        sub.add_user(user)
        return

    @staticmethod
    def get_personal_sub(user):
        """
        Retrieves the personal subscription list for a given CommonUser.
        :param user: the CommonUser
        :type user: CommonUser
        :return: the personal Subscription list
        :rtype: Subscription
        """
        dev = Developer.get_personal_dev()
        return Subscription.objects.get(owner=dev, user_id=user.id)


class SubscriptionCreationForm(forms.Form):
    """
    A form for a developer to create a subscription
    """
    api_key = forms.CharField(label='Developer API Key:', max_length=43)
    name = forms.CharField(label='Subscription Name', max_length=50)
    description = forms.CharField(label='Subscription Description', max_length=300)

    def save(self, commit=True):
        """
        Saves the SusbcriptionCreationForm as a Subscription.
        :param commit: if true then the Subscription is saved/commited to the database
        :type commit: bool
        :return: the Subscription
        :rtype: Subscription
        """
        dev = Developer.objects.get(api_key=self.cleaned_data['api_key'])
        sub = dev.create_subscription(name=self.cleaned_data['name'],
                                      description=self.cleaned_data['description'])
        if commit:
            sub.save()
        return sub


class PushNotificationForm(forms.Form):
    """
    Form to push a Notification from Developer to User.
    """
    api_key = forms.CharField(label='Developer API Key:', max_length=43)
    sub_id = forms.IntegerField(label='Subscription ID:')
    contents = forms.CharField(max_length=300)
    url = forms.URLField(required=False)

    def save(self, commit=True):
        """
        Saves the SusbcriptionCreationForm as a DeveloperNotification and pushes the resulting Notification.
        :param commit: if true then the Subscription is saved/commited to the database
        :type commit: bool
        :return: the DeveloperNotification
        :rtype: DeveloperNotification
        """
        dev = Developer.objects.get(api_key=self.cleaned_data['api_key'])
        sub = dev.subscription_set.get(id=self.cleaned_data['sub_id'])
        notif = sub.create_notification(contents=self.cleaned_data['contents'],
                                        url=self.cleaned_data['url'])
        if commit:
            notif.save()
        return notif


class Notification(models.Model):
    """
    The interface of both types of notifications that we have, User and Developer.
    This stores the information for a notification sent from a Developer or User to Users.

    We decided to use an abstract base class for a greater ability to expand our options in the future.
    """
    sender = models.ForeignKey(django.contrib.auth.models.User)
    contents = models.CharField(max_length=300)
    creation_date = models.DateTimeField('date created', auto_now_add=True, editable=False)
    url = models.URLField(default="")

    def get_actions(self):
        """
        Gets the "actions" for APNS.
        :return: the actions
        :rtype: str
        """
        return ""

    def get_ios_display(self):
        """
        Gets the "display" for APNS.
        :return: the display
        :rtype: str
        """
        return ""

    class Meta:
        abstract = True


class DeveloperNotification(Notification):
    """
    A notification sent from a Developer to a User through a Subscription.
    This also denotes a User-->User forward although the Subscription owner will always be the "fake" Developer for
    these.
    """
    subscription = models.ForeignKey(Subscription)

    def push(self):
        """
        Pushes the DeveloperNotification to all subscribed CommonUser's (including all of their individual registered
        devices) using pyapns (which MUST be running on localhost:7077).
        :return:
        """
        configure({'HOST': 'http://localhost:7077/'})
        provision('HiNote', open('apns-dev.pem').read(), 'sandbox')
        settings = self.subscription.subscriptionsettings_set.all()
        users = [setting.user for setting in settings]
        for user in users:
            for device in user.iosdevice_set.all():
                token = str(device.token)
                notify('HiNote', token, {'aps': {'alert': str(self.contents),
                                                 'url': str(self.url)}})
