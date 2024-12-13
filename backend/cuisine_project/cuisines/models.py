from django.db import models

class Cuisine(models.Model):
    cuisine_title = models.CharField(max_length=255)
    image = models.ImageField(upload_to='cuisines/', null=True, blank=True)
    categories = models.ManyToManyField('Category', related_name='cuisines', blank=True)

    def __str__(self):
        return self.cuisine_title

class Category(models.Model):
    category_title = models.CharField(max_length=255)
    image = models.ImageField(upload_to='categories/', null=True, blank=True)
    subcategories = models.ManyToManyField('Subcategory', related_name='categories', blank=True)

    def __str__(self):        
        return self.category_title

class Subcategory(models.Model):
    subcategory_title = models.CharField(max_length=255)
    image = models.ImageField(upload_to='subcategories/', null=True, blank=True)

    def __str__(self):
        return self.subcategory_title