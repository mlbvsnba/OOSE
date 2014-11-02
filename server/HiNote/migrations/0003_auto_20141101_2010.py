# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('HiNote', '0002_auto_20141101_1833'),
    ]

    operations = [
        migrations.AlterField(
            model_name='developer',
            name='api_key',
            field=models.CharField(max_length=50, editable=False),
            preserve_default=True,
        ),
    ]
