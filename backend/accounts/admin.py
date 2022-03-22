from django.contrib import admin

from accounts.models import User


@admin.register(User)
class UserAdmin(admin.ModelAdmin):
    list_display = ["mobile", "full_name", "username", "email", "is_customer", "is_restaurant", "is_delivery_person"]
    search_fields = ["full_name", "mobile", "email", "username"]
    list_filter = ["is_customer", "is_restaurant", "is_delivery_person"]