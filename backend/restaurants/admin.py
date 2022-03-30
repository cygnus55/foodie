from django.contrib import admin
from django.urls import path
from django.db import models

from django_better_admin_arrayfield.admin.mixins import DynamicArrayMixin

from restaurants.models import Restaurant
from restaurants.views import register


class RegisterRestaurant(models.Model):
    class Meta:
        verbose_name_plural = 'Register Restaurants'


class RegisterRestaurantAdmin(admin.ModelAdmin):
    model = RegisterRestaurant

    def get_urls(self):
        view_name = '{}_{}_changelist'.format(self.model._meta.app_label, self.model._meta.model_name)
        return [
            path('register/', register, name=view_name),
        ]

admin.site.register(RegisterRestaurant, RegisterRestaurantAdmin)


@admin.register(Restaurant)
class RestaurantAdmin(admin.ModelAdmin):
    model = Restaurant
    list_display = ["user", "open_hour", "close_hour", "ratings_count", "average_ratings", "is_available", "logo"]
    list_filter = ["is_available"]
    list_editable = ["is_available"]