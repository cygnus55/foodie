from django.urls import path

from customers.views import CustomerProfile

app_name = 'customers'

urlpatterns = [
    path('profile/', CustomerProfile.as_view(), name='profile')
]