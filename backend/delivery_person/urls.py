from django.urls import path

from delivery_person.views import ChangePassword, DeliveryPersonProfile, NewOrderList

app_name = 'delivery_person'

urlpatterns = [
    path('change-password/', ChangePassword.as_view(), name='change_password'),
    path('profile/', DeliveryPersonProfile.as_view(), name='profile'),
    path('new-orders/', NewOrderList.as_view(), name='new_orders'),
]