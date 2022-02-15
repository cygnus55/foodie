from django.urls import path

from foods.views import FoodList, FoodDetails


app_name = "foods"

urlpatterns = [
    path("", FoodList.as_view(), name="food_list"),
    path("<int:pk>/", FoodDetails.as_view(), name="food_details"),
]