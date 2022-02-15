from django.urls import path

from api.views import APIRoot


app_name = "api"

urlpatterns = [
    path("", APIRoot.as_view(), name="api-root"),
]