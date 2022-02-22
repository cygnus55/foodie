from django.urls import path

from cart.views import CartDetails, CartItemsDetails

app_name = 'cart'

urlpatterns = [
    path('', CartDetails.as_view(), name='detail'),
    path('items/<int:pk>/', CartItemsDetails.as_view(), name='cart_item')
]