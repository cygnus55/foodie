from ast import Or
from django.urls import path

from orders.views import OrderCreate, OrderList, DeliveryLocation, Geocoding

app_name = 'orders'

urlpatterns = [
    path('create/', OrderCreate.as_view(), name='create'),
    path('', OrderList.as_view(), name='list'),
    path('delivery-location/', DeliveryLocation.as_view(), name='delivery_location'),
    path('geocode/', Geocoding.as_view(), name='geocoding'),
]
