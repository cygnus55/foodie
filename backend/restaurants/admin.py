from django.contrib import admin

from django_better_admin_arrayfield.admin.mixins import DynamicArrayMixin

from restaurants.models import Restaurant


@admin.register(Restaurant)
class RestaurantAdmin(admin.ModelAdmin, DynamicArrayMixin):
    list_display = ["user", "open_hour", "close_hour", "ratings_count", "average_ratings", "is_available"]
    list_filter = ["is_available"]
    list_editable = ["is_available"]