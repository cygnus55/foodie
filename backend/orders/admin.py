from django.contrib import admin
from django_better_admin_arrayfield.admin.mixins import DynamicArrayMixin

from orders.models import Order, OrderItem

# Register your models here.


class OrderItemInline(admin.TabularInline):
    model = OrderItem
    raw_id_fields = ('food',)


@admin.register(Order)
class OrderAdmin(admin.ModelAdmin, DynamicArrayMixin):
    inlines = [OrderItemInline]
    list_display = ['customer', 'delivery_location', 'status', 'total_amount']
    list_filter = ['status']
    list_editable = ['status']
