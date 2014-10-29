from django.db import models


# maybe use django's built in User class as it has
# authentication / session management?
class User(models.Model):
    name = models.CharField(max_length=100, unique=True)
    email_address = models.EmailField()
    creation_date = models.DateTimeField('date created', auto_now_add=True, editable=False)


class CommonUser(User):
    subscriptions = models.ManyToManyField('Subscription')


class Developer(User):
    api_key = models.CharField(max_length=50)

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
    creation_date = models.DateTimeField('date created', auto_now_add=True, editable=False)


class Notification(models.Model):
    sender = models.ForeignKey(User)
    contents = models.CharField(max_length=300)
    creation_date = models.DateTimeField('date created', auto_now_add=True, editable=False)

    def get_sender(self):
        pass

    def get_actions(self):
        pass

    def get_ios_display(self):
        pass


class DeveloperNotification(Notification):
    # should use a pre-init to verify the sender is a Developer.  Similar to
    # http://stackoverflow.com/questions/9415616/adding-to-the-constructor-of-a-django-model
    pass
