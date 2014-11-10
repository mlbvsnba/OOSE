from django import forms
from django.db import models
import django.contrib.auth.models
from django.forms import ModelForm


class CommonUser(django.contrib.auth.models.User):
    pass


class SubscriptionSettings(models.Model):
    #  Many-to-one relationships
    user = models.ForeignKey('CommonUser')
    subscription = models.ForeignKey('Subscription')
    receive_notifications = models.BooleanField(default=True)
    radius_in_miles = models.IntegerField(default=-1)
    notification_frequency = models.IntegerField(default=-1)


class Developer(django.contrib.auth.models.User):
    api_key = models.CharField(max_length=43, blank=False)

    def verify_api_key(self, api_key):
        """
        Verifies a Developer's API key.
        :param api_key string
        """
        assert isinstance(api_key, str)
        return self.api_key == api_key

    def create_subscription(self, name, description):
        sub = self.subscription_set.create(owner=self, name=name,
                                           description=description)
        return sub

    @staticmethod
    def create_api_key():
        # method from http://jetfar.com/simple-api-key-generation-in-python/
        import random
        import hashlib
        import base64
        h = hashlib.sha256(str(random.getrandbits(256))).digest()
        rand = random.choice(['rA','aZ','gQ','hH','hG','aR','DD'])
        return base64.b64encode(h, rand).rstrip('==')


class DeveloperForm(ModelForm):
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
    # many-to-one relationship
    owner = models.ForeignKey(Developer, editable=False)
    name = models.CharField(max_length=50)
    description = models.CharField(max_length=300)
    creation_date = models.DateTimeField('date created', auto_now_add=True, editable=False)

    def create_notification(self, contents):
        notif = self.developernotification_set.create(sender=self.owner, contents=contents)
        return notif


class SubscriptionCreationForm(forms.Form):
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
    sender = models.ForeignKey(django.contrib.auth.models.User)
    contents = models.CharField(max_length=300)
    creation_date = models.DateTimeField('date created', auto_now_add=True, editable=False)

    def get_actions(self):
        # will be fleshed out later
        pass

    def get_ios_display(self):
        # will be fleshed out later
        pass

    class Meta:
        abstract = True


class DeveloperNotification(Notification):
    # Many-to-One relationship
    subscription = models.ForeignKey(Subscription)

    # maybe use a pre-init to verify the sender is a Developer.  Similar to
    # http://stackoverflow.com/questions/9415616/adding-to-the-constructor-of-a-django-model
    pass


class UserNotification(Notification):
    # Many-to-One relationship
    recipient = models.ForeignKey(CommonUser, related_name='recipient')

    pass
