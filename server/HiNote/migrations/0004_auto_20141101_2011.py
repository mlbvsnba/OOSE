# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('HiNote', '0003_auto_20141101_2010'),
    ]

    operations = [
        migrations.AlterField(
            model_name='developer',
            name='api_key',
            field=models.CharField(max_length=50),
            preserve_default=True,
        ),
    ]
