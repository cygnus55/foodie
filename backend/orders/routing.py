import imp
from django.urls import re_path
from orders.consumer import OrderStatusConsumer

websocket_urlpatterns = [
    re_path(r'ws/order-status/(?P<order_id>\d+)/$', OrderStatusConsumer.as_asgi()),
]