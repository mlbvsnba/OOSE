from django import forms
from django.core.exceptions import ObjectDoesNotExist
from django.db import models
import django.contrib.auth.models
from django.forms import ModelForm
# import pyapns_wrapper
import sys
from pyapns import configure, provision, notify


class CommonUser(django.contrib.auth.models.User):
    ## Django's built-in common (non-developer) user.
    # This user can subscribe to lists and has a SubscriptionSettings object for each list it is subscribed to.
    # By using the django User base-class, we can have assured security with regards to user authentication.

    def register_device(self, device_token, commit=True):
        device = self.iosdevice_set.create(token=device_token)
        if commit and device is not None:
            device.save()
        return device

    def create_personal_subscription(self):
        Subscription.create_personal_sub(self)


class IOSDevice(models.Model):
    user = models.ForeignKey(CommonUser)
    token = models.CharField(max_length=64, blank=False, null=False)


class CommonUserForm(ModelForm):
    class Meta:
        model = CommonUser
        fields = ['first_name', 'last_name', 'email', 'username', 'password']

    def save(self, commit=True):
        user = super(CommonUserForm, self).save(commit=commit)
        user.set_password(self.cleaned_data["password"])
        if commit:
            user.create_personal_subscription()
        if commit:
            user.save()
        return user


class SubscriptionSettings(models.Model):
    ## A specific User's settings for a Subscription.

    user = models.ForeignKey('CommonUser')
    subscription = models.ForeignKey('Subscription')
    receive_notifications = models.BooleanField(default=True)
    radius_in_miles = models.IntegerField(default=-1)
    notification_frequency = models.IntegerField(default=-1)


class Developer(django.contrib.auth.models.User):
    PERSONAL_USERNAME = 'PERSONAL_DEV'
    ## A Developer who can create and push Notifications to Subscriptions that it creates.
    api_key = models.CharField(max_length=43, blank=False)

    @staticmethod
    def get_personal_dev():
        try:
            dev = Developer.objects.get(username=Developer.PERSONAL_USERNAME)
        except ObjectDoesNotExist:
            dev = Developer.objects.create(api_key=Developer.create_api_key(),
                                           username=Developer.PERSONAL_USERNAME)
            dev.set_password(Developer.PERSONAL_USERNAME)
            dev.save()
        return dev

    def verify_api_key(self, api_key):
        ##Verifies a Developer's API key.
        # @param self The object pointer.
        # @param api_key string
        # @return True if they're equal, false otherwise
        assert isinstance(api_key, str)
        return self.api_key == api_key

    def create_subscription(self, name, description):
        ##Creates a Subscription under this Developer.
        # @param self The object pointer.
        # @param name the name of the Subscription
        # @param description the description of this Subscription
        sub = self.subscription_set.create(owner=self, name=name,
                                           description=description)
        return sub

    @staticmethod
    def create_api_key():
        ##Creates a new api key for a new Developer.
        # method from http://jetfar.com/simple-api-key-generation-in-python/
        # @return the new api key
        import random
        import hashlib
        import base64
        h = hashlib.sha256(str(random.getrandbits(256))).digest()
        rand = random.choice(['rA','aZ','gQ','hH','hG','aR','DD'])
        return base64.b64encode(h, rand).rstrip('==')


class DeveloperForm(ModelForm):
    ##Form to create a developer account
    class Meta:
        model = Developer
        fields = ['first_name', 'last_name', 'email', 'username', 'password']

    def save(self, commit=True):
        dev = super(DeveloperForm, self).save(commit=False)
        dev.set_password(self.cleaned_data["password"])
        if not dev.api_key:
            dev.api_key = Developer.create_api_key()
        if commit:
            dev.save()
        return dev


class Subscription(models.Model):
    ## A Subscription list which is owned by a Developer and contains Users.
    owner = models.ForeignKey(Developer, editable=False)
    name = models.CharField(max_length=50)
    description = models.CharField(max_length=300)
    creation_date = models.DateTimeField('date created', auto_now_add=True, editable=False)
    is_personal = models.BooleanField(default=False)
    user_id = models.IntegerField(null=True)

    def add_user(self, user, save=True):
        # Adds a user to this subscriptions list of subscribers
        # @param user the common user to add
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

    def create_notification(self, contents):
        # Creates a Notification
        # @param self The object pointer.
        # @param contents the content of the Notification
        notif = self.developernotification_set.create(sender=self.owner, contents=contents)
        notif.push()
        return notif

    @staticmethod
    def create_personal_sub(user):
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
        dev = Developer.get_personal_dev()
        return Subscription.objects.get(owner=dev, user_id=user.id)


class SubscriptionCreationForm(forms.Form):
    ##A form for a developer to create a subscription
    api_key = forms.CharField(label='Developer API Key:', max_length=43)
    name = forms.CharField(label='Subscription Name', max_length=50)
    description = forms.CharField(label='Subscription Description', max_length=300)

    def save(self, commit=True):
        dev = Developer.objects.get(api_key=self.cleaned_data['api_key'])
        sub = dev.create_subscription(name=self.cleaned_data['name'], description=self.cleaned_data['description'])
        if commit:
            sub.save()
        return sub


class PushNotificationForm(forms.Form):
    ##Form to push a Notification from Developer to User
    api_key = forms.CharField(label='Developer API Key:', max_length=43)
    sub_id = forms.IntegerField(label='Subscription ID:')
    contents = forms.CharField(max_length=300)

    def save(self, commit=True):
        dev = Developer.objects.get(api_key=self.cleaned_data['api_key'])
        sub = dev.subscription_set.get(id=self.cleaned_data['sub_id'])
        notif = sub.create_notification(contents=self.cleaned_data['contents'])
        if commit:
            notif.save()
        return notif


class Notification(models.Model):
    ##The interface of both types of notifications that we have, User and Developer.
    # This stores the information for a notification sent from a Developer or User to Users.
    sender = models.ForeignKey(django.contrib.auth.models.User)
    contents = models.CharField(max_length=300)
    creation_date = models.DateTimeField('date created', auto_now_add=True, editable=False)
    url = models.URLField(null=True)

    def get_actions(self):
        # will be fleshed out later
        pass

    def get_ios_display(self):
        # will be fleshed out later
        pass

    class Meta:
        abstract = True


class DeveloperNotification(Notification):
    ##A notification sent from a Developer to a User through a Subscription
    subscription = models.ForeignKey(Subscription)

    # maybe use a pre-init to verify the sender is a Developer.  Similar to
    # http://stackoverflow.com/questions/9415616/adding-to-the-constructor-of-a-django-model

    def push(self):
        configure({'HOST': 'http://localhost:7077/'})
        provision('HiNote', open('apns-dev.pem').read(), 'sandbox')
        settings = self.subscription.subscriptionsettings_set.all()
        users = [setting.user for setting in settings]
        for user in users:
            for device in user.iosdevice_set.all():
                token = str(device.token)
                notify('HiNote', token, {'aps':{'alert': str(self.contents),
                                                'url': str(self.url)}})


class UserNotification(Notification):
    ##A notification sent from a User to another User through a Subscription
    recipient = models.ForeignKey(CommonUser, related_name='recipient')

    pass
