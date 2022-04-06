from django.urls import path

from delivery_person.views import ChangePassword, DeliveryPersonProfile, NewOrderList, AcceptOrder, UpdateStatus

app_name = 'delivery_person'

urlpatterns = [
    path('change-password/', ChangePassword.as_view(), name='change_password'),
    path('profile/', DeliveryPersonProfile.as_view(), name='profile'),
    path('new-orders/', NewOrderList.as_view(), name='new_orders'),
    path('accept-order/', AcceptOrder.as_view(), name='accept_order'),
    path('update-status/', UpdateStatus.as_view(), name='update_status'),
]