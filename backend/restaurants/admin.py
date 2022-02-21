from django.contrib import admin

from restaurants.models import Restaurant


@admin.register(Restaurant)
class RestaurantAdmin(admin.ModelAdmin):
    list_display = ["user", "open_hour", "close_hour", "is_available"]
    list_filter = ["is_available"]
    list_editable = ["is_available"]