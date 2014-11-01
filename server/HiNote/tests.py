from django.test import TestCase
from HiNote.models import Developer
from HiNote.models import CommonUser
from HiNote.models import Subscription
from HiNote.models import DeveloperNotification
from HiNote.models import UserNotification
from django.core.exceptions import *

from django.contrib.auth import authenticate


class DeveloperTestCase(TestCase):

    def test_creation(self):
        key = Developer.create_api_key()
        dev = Developer.objects.create(api_key=key, username="dev1",
                                       password="dev1", email="dev1@dev1.com",
                                       first_name="John", last_name="Smith")
        dev.save()
        dev_load = Developer.objects.get(api_key=key)
        self.assertIsNotNone(dev_load)
        self.assertEquals(dev.username, dev_load.username)
        self.assertEquals(dev.password, dev_load.password)
        self.assertEquals(dev.email, dev_load.email)
        self.assertEquals(dev.first_name, dev_load.first_name)
        self.assertEquals(dev.last_name, dev_load.last_name)

    def test_fake(self):
        self.assertRaises(ObjectDoesNotExist, Developer.objects.get,
                          api_key="fake key")


class UserTestCase(TestCase):
    def test_creation(self):
        usr = CommonUser.objects.create(username="usr1",
                                        password="usr11", email="usr1@usr.com",
                                        first_name="John", last_name="Smith")
        usr.save()
        usr_load = CommonUser.objects.get(username="usr1")
        self.assertIsNotNone(usr_load)
        self.assertEquals(usr.username, usr_load.username)
        self.assertEquals(usr.password, usr_load.password)
        self.assertEquals(usr.email, usr_load.email)
        self.assertEquals(usr.first_name, usr_load.first_name)
        self.assertEquals(usr.last_name, usr_load.last_name)


class SubscriptionTestCase(TestCase):
    def test_creation(self):
        key = Developer.create_api_key()
        dev = Developer.objects.create(api_key=key, username="dev1",
                                       password="dev1", email="dev1@dev1.com",
                                       first_name="John", last_name="Smith")
        dev.save()
        sub = dev.create_subscription(name="sub1", description="this is a subscription")
        sub_load = Subscription.objects.get(name="sub1")
        self.assertIsNotNone(sub_load)
        self.assertEquals(sub_load.owner, dev)
        self.subs_equal(sub_load, sub)
        sub_set = dev.subscription_set
        self.assertIsNotNone(sub_set)
        subs = sub_set.all()
        self.assertEquals(len(subs), 1)
        s = subs[0]
        self.subs_equal(s, sub)

    def subs_equal(self, a, b):
        self.assertEquals(a.owner, b.owner)
        self.assertEquals(a.name, b.name)
        self.assertEquals(a.description, b.description)


# class DeveloperNotificationTestCase(TestCase):
#     def test_creation(self):
#         key = Developer.create_api_key()
#         dev = Developer.objects.create(api_key=key, username="dev1",
#                                        password="dev1", email="dev1@dev1.com",
#                                        first_name="John", last_name="Smith")
#         dev.save()
#         sub = Developer.create_subscription(dev, "sub1", "this is a subscription")
#         devNot = DeveloperNotification.objects.create(sender=dev, contents="this is a notification",
#                                                       subscription=sub)
#         devNot.save()
#         devNot_load = DeveloperNotification.objects.get()
#         self.assertIsNotNone(devNot_load)
#         self.assertEquals(devNot.Sender, devNot_load.sender)
#         self.assertEquals(devNot.contents, devNot_load.contents)
#         self.assertEquals(devNot.subscription, devNot_load.subscription)
#
# class UserNotificationTestCase(TestCase):
#     def test_creation(self):
#         usrSender = CommonUser.objects.create(username="usr1",
#                                         password="usr11", email="usr1@usr.com",
#                                        first_name="John", last_name="Smith")
#         usrSender.save()
#         usrReceiver = CommonUser.objects.create(username="usr2",
#                                         password="usr22", email="usr2@usr.com",
#                                        first_name="Jane", last_name="Doe")
#         usrReceiver.save()
#         usrNot = UserNotification.objects.create(sender = usrSender, contents = "this is a notification", receiver = usrReceiver)
#         usrNot.save()
#         usrNot_load = UserNotification.objects.get()
#         self.assertIsNotNone(usrNot_load)
#         self.assertEquals(usrNot.Sender, usrNot_load.sender)
#         self.assertEquals(usrNot.contents, usrNot_load.contents)
#         self.assertEquals(usrNot.receiver, usrNot_load.usrReceiver)
