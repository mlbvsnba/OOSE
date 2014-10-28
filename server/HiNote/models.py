from django.db import models


class User(models.Model):
    name = models.CharField(max_length=100)
    creation_date = models.DateTimeField('date created')


class Developer(User):
    api_ky = models.CharField(max_length=50)

    def verify(self, api_key):
        """
        Verifies a Developer's API key.
        :param api_key string
        """
        return self.api_key == api_key

    def create_subscription(self, name, description):
        sub = Subscription(owner=self, name=name, description=description)
        sub.save()

    def push_notification(self, notification, subscription_key):
        """
        Pushes a given notification to the matching subscription.
        :param notification: a DeveloperNotification to push
        :param subscription_key: the integer key of the Developer's subscription to push to
        """
        pass


class Subscription(models.Model):
    # many-to-one relationship
    owner = models.ForeignKey(Developer, related_name='subscription')
    name = models.CharField(max_length=50)
    description = models.CharField(max_length=300)
    creation_date = models.DateTimeField('date created')

    def __init__(self, owner, name, description):
        super(Subscription, self).__init__()
        self.owner = owner
        self.name = name
        self.description = description