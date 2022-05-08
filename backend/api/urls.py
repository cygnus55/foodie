from django.urls import path

from api.views import APIRoot, Search


app_name = "api"

urlpatterns = [
    path("", APIRoot.as_view(), name="api-root"),
    path("search/", Search.as_view(), name="search")
]