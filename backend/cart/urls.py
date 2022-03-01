from django.urls import path

from cart.views import CartDetails, CartItemsDetails, CartItemCreate

app_name = 'cart'

urlpatterns = [
    path('', CartDetails.as_view(), name='detail'),
    path('items/<int:pk>/', CartItemsDetails.as_view(), name='cart_item'),
    path('add/', CartItemCreate.as_view(), name='add_item'),
]
