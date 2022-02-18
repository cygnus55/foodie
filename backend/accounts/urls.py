from django.urls import path
from .views import customer_login, account_logout, send_otp_code, customer_name

app_name = 'accounts'

urlpatterns = [
    path('send-otp/', send_otp_code, name='send_otp'),
    path('login/', customer_login, name='customer_login'),
    path('logout/', account_logout, name='logout'),

    # Customer centric urls
    path('customer-name/', customer_name, name='customer_name'),
]
