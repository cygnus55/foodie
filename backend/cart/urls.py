from django.urls import path

from cart.views import CartDetails, CartItemsDetails, CartItemCreate, ClearCartItemByRestaurant

app_name = 'cart'

urlpatterns = [
    path('', CartDetails.as_view(), name='detail'),
    path('items/<int:pk>/', CartItemsDetails.as_view(), name='cart_item'),
    path('add/', CartItemCreate.as_view(), name='add_item'),
    path('clear/restaurant/', ClearCartItemByRestaurant.as_view(), name='clear_cart_item_by_restaurant'),
]
