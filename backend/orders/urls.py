from ast import Or
from django.urls import path

from orders.views import OrderCreate, OrderList, RecentDeliveryLocation, GetDeliveryCharge

app_name = 'orders'

urlpatterns = [
    path('create/', OrderCreate.as_view(), name='create'),
    path('', OrderList.as_view(), name='list'),
    path('delivery-location/', RecentDeliveryLocation.as_view(), name='delivery_location'),
    path('delivery-charge/', GetDeliveryCharge.as_view(), name='delivery_charge'),
]
