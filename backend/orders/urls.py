from ast import Or
from django.urls import path

from orders.views import OrderCreate, OrderList

app_name = 'orders'

urlpatterns = [
    path('create/', OrderCreate.as_view(), name='create'),
    path('', OrderList.as_view(), name='list'),
]
