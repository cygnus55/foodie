from django.contrib import admin

from accounts.models import User


@admin.register(User)
class UserAdmin(admin.ModelAdmin):
    list_display = ['mobile', 'username', 'email', 'is_customer', 'is_restaurant', 'is_delivery_person']
    search_fields = ['mobile', 'email', 'username']
    list_filter = ['is_customer', 'is_restaurant', 'is_delivery_person']