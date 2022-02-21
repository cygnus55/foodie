from django.urls import path

from foods.views import (
    FoodList, 
    FoodDetails, 
    FoodTemplateList, 
    FoodTemplateDetailsView
)

app_name = "foods"

urlpatterns = [
    path("", FoodList.as_view(), name="food_list"),
    path("<int:pk>/", FoodDetails.as_view(), name="food_details"),
    path("templates/", FoodTemplateList.as_view(), name="food_template_list"),
    path("templates/<int:pk>/", FoodTemplateDetailsView.as_view(), name="food_template_details"),
]