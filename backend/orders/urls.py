from ast import Or
from django.urls import path

from orders.views import OrderCreate, OrderList, RecentDeliveryLocation, GetDeliveryCharge, order_status

app_name = 'orders'

urlpatterns = [
    path('create/', OrderCreate.as_view(), name='create'),
    path('', OrderList.as_view(), name='list'),
    path('delivery-location/', RecentDeliveryLocation.as_view(), name='delivery_location'),
    path('delivery-charge/', GetDeliveryCharge.as_view(), name='delivery_charge'),
    path('order-status/<int:order_id>/', order_status, name="order_status"),
]
