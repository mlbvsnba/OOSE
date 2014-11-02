# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('HiNote', '0004_auto_20141101_2011'),
    ]

    operations = [
        migrations.AddField(
            model_name='subscriptionsettings',
            name='notification_frequency',
            field=models.IntegerField(default=-1),
            preserve_default=True,
        ),
        migrations.AddField(
            model_name='subscriptionsettings',
            name='radius_in_miles',
            field=models.IntegerField(default=-1),
            preserve_default=True,
        ),
        migrations.AddField(
            model_name='subscriptionsettings',
            name='receive_notifications',
            field=models.BooleanField(default=True),
            preserve_default=True,
        ),
    ]
