from django.contrib import admin

from foods.models import Food, FoodTemplate


@admin.register(Food)
class FoodAdmin(admin.ModelAdmin):
    list_display = ["name", "description", "price", "discount_percent", "selling_price", "ratings_count", "average_ratings", "restaurant", "is_available", "is_veg"]
    search_fields = ["name"]
    list_filter = ["is_available", "is_veg"]
    list_editable = ["is_available", "is_veg"]


@admin.register(FoodTemplate)
class FoodTemplateAdmin(admin.ModelAdmin):
    list_display = ["name", "description", "price", "is_available", "is_veg"]
    search_fields = ["name"]
    list_filter = ["is_available", "is_veg"]
    list_editable = ["is_available", "is_veg"]
