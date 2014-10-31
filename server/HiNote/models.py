from django.db import models
import django.contrib.auth.models


class CommonUser(models.Model):
    pass


class SubscriptionSettings(models.Model):
    #  Many-to-one relationships
    user = models.ForeignKey('CommonUser')
    subscription = models.ForeignKey('Subscription')


class Developer(django.contrib.auth.models.User):
    api_key = models.CharField(max_length=50, blank=False)

    def verify_api_key(self, api_key):
        """
        Verifies a Developer's API key.
        :param api_key string
        """
        assert isinstance(api_key, str)
        return self.api_key == api_key

    def create_subscription(self, name, description):
        sub = Subscription(owner=self, name=name, description=description)
        sub.save()

    @staticmethod
    def create_api_key():
        # method from http://jetfar.com/simple-api-key-generation-in-python/
        import random
        import hashlib
        import base64
        h = hashlib.sha256(str(random.getrandbits(256))).digest()
        rand = random.choice(['rA','aZ','gQ','hH','hG','aR','DD'])
        return base64.b64encode(h, rand).rstrip('==')


class Subscription(models.Model):
    # many-to-one relationship
    owner = models.ForeignKey(Developer, related_name='subscription', editable=False)
    name = models.CharField(max_length=50)
    description = models.CharField(max_length=300)
    creation_date = models.DateTimeField('date created', auto_now_add=True, editable=False)

    def push_notification(self, notification):
        """
        Pushes a given notification to the matching subscription.
        :param notification: a DeveloperNotification to push
        :param subscription_key: the integer key of the Developer's subscription to push to
        """
        pass


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


class DeveloperNotification(Notification):
    # Many-to-One relationship
    subscription = models.ForeignKey(Subscription)

    # maybe use a pre-init to verify the sender is a Developer.  Similar to
    # http://stackoverflow.com/questions/9415616/adding-to-the-constructor-of-a-django-model
    pass


class UserNotification(Notification):
    # Many-to-One relationship
    recipient = models.ForeignKey(CommonUser)

    pass