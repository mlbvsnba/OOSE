# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('HiNote', '0003_auto_20141216_1514'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='usernotification',
            name='recipient',
        ),
        migrations.RemoveField(
            model_name='usernotification',
            name='sender',
        ),
        migrations.DeleteModel(
            name='UserNotification',
        ),
        migrations.AddField(
            model_name='subscription',
            name='is_personal',
            field=models.BooleanField(default=False),
            preserve_default=True,
        ),
        migrations.AddField(
            model_name='subscription',
            name='user_id',
            field=models.IntegerField(null=True),
            preserve_default=True,
        ),
        migrations.AlterField(
            model_name='developernotification',
            name='url',
            field=models.URLField(default=b''),
            preserve_default=True,
        ),
    ]
