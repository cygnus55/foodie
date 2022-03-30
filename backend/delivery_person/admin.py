from django.contrib import admin
from django.urls import path
from django.db import models

from delivery_person.models import DeliveryPerson
from delivery_person.views import register


class RegisterDeliveryUser(models.Model):
    class Meta:
        verbose_name_plural = 'Register Delivery Users'


class RegisterDeliveryUserAdmin(admin.ModelAdmin):
    model = RegisterDeliveryUser

    def get_urls(self):
        view_name = '{}_{}_changelist'.format(self.model._meta.app_label, self.model._meta.model_name)
        return [
                path('register/', register, name=view_name),
            ]

admin.site.register(RegisterDeliveryUser, RegisterDeliveryUserAdmin)


@admin.register(DeliveryPerson)
class DeliveryPersonAdmin(admin.ModelAdmin):
    model = DeliveryPerson
    list_diaplay = ['user', 'profile_picture']