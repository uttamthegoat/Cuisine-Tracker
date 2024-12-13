# Generated by Django 5.1.4 on 2024-12-13 11:09

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('cuisines', '0001_initial'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='category',
            name='cuisines',
        ),
        migrations.RemoveField(
            model_name='subcategory',
            name='categories',
        ),
        migrations.AddField(
            model_name='category',
            name='subcategories',
            field=models.ManyToManyField(related_name='categories', to='cuisines.subcategory'),
        ),
        migrations.AddField(
            model_name='cuisine',
            name='categories',
            field=models.ManyToManyField(related_name='cuisines', to='cuisines.category'),
        ),
    ]
