from django.db import models

# Create your models here.

class User(models.Model):
    name = models.CharField(max_length=100)
    creation_date = models.DateTimeField('date created')

class Developer(User):
    api_key = models.CharField(max_length=50)
    
    def verify(self, api_key):
        """

        :type api_key: string
        """
        return self.api_key == api_key