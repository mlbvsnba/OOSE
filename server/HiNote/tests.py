from django.test import TestCase
from HiNote.models import Developer
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

