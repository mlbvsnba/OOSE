# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('HiNote', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='IOSDevice',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('token', models.CharField(max_length=64)),
                ('user', models.ForeignKey(to='HiNote.CommonUser')),
            ],
            options={
            },
            bases=(models.Model,),
        ),
    ]
