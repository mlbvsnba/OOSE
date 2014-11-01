# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('HiNote', '0001_initial'),
    ]

    operations = [
        migrations.AlterField(
            model_name='subscription',
            name='owner',
            field=models.ForeignKey(editable=False, to='HiNote.Developer'),
            preserve_default=True,
        ),
    ]
