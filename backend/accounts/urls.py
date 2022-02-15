from django.urls import path
from .views import account_login, account_logout, send_otp_code

app_name = 'accounts'

urlpatterns = [
    path('send-otp/', send_otp_code, name='send_otp'),
    path('login/', account_login, name='login'),
    path('logout/', account_logout, name='logout'),
]
