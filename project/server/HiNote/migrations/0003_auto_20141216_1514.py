# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('HiNote', '0002_iosdevice'),
    ]

    operations = [
        migrations.AddField(
            model_name='developernotification',
            name='url',
            field=models.URLField(null=True),
            preserve_default=True,
        ),
        migrations.AddField(
            model_name='usernotification',
            name='url',
            field=models.URLField(null=True),
            preserve_default=True,
        ),
    ]
