from django.core.validators import MaxValueValidator, MinValueValidator
from django.core.exceptions import ObjectDoesNotExist
from django.contrib.contenttypes.fields import GenericRelation
from django.db import models
from django.db.models import Avg, Count
from decimal import Decimal

from taggit.managers import TaggableManager

from restaurants.models import Restaurant
from reviews.models import Review
from favourites.models import Favourite
from api.custom_managers import AvailabilityManager
from customers.models import Customer


class Food(models.Model):
    name = models.CharField(max_length=200)
    description = models.TextField(blank=True)
    price = models.DecimalField(max_digits=10, decimal_places=2, validators=[MinValueValidator(Decimal("0.01"))])
    is_available = models.BooleanField(default=True)
    image = models.URLField(max_length=1000, blank=True)
    discount_percent = models.IntegerField(
        default=0,
        validators=[
            MaxValueValidator(100),
            MinValueValidator(0)
        ]
    )
    restaurant = models.ForeignKey(
        Restaurant,
        related_name="foods",
        on_delete=models.CASCADE
    )
    is_veg = models.BooleanField(default=False)
    reviews = GenericRelation(
        Review,
        related_query_name="food",
        content_type_field="content_type",
        object_id_field="object_id",
    )
    favourites = GenericRelation(
        Favourite,
        related_query_name="food",
        content_type_field="content_type",
        object_id_field="object_id",
    )
    created = models.TimeField(auto_now_add=True)
    updated = models.TimeField(auto_now=True)

    # Managers
    objects = models.Manager()
    available = AvailabilityManager()
    tags = TaggableManager()

    class Meta:
        ordering = ("-is_available", "-discount_percent", "name",)

    @property
    def selling_price(self):
        return self.price - (self.price * self.discount_percent/100)

    @property
    def average_ratings(self):
        avg_ratings = self.reviews.aggregate(Avg("ratings")).get("ratings__avg", 0)
        if avg_ratings == None: avg_ratings = 0
        return avg_ratings

    @property
    def ratings_count(self):
        ratings_cnt = self.reviews.aggregate(Count("ratings")).get("ratings__count", 0)
        if ratings_cnt == None: ratings_cnt = 0
        return ratings_cnt

    def customer_favourite_status(self, id):
        try:
            customer = Customer.objects.get(id=id)
            item = self.favourites.filter(customer=customer)
            if item:
                return True
            return False
        except ObjectDoesNotExist:
            return False

    @property
    def can_be_ordered(self):
        return self.is_available and self.restaurant.is_available and self.restaurant.open_status

    def __str__(self):
        return f"Food: {self.name} for restaurant {self.restaurant.user.full_name}"


class FoodTemplate(models.Model):
    name = models.CharField(max_length=200)
    description = models.TextField(blank=True)
    price = models.DecimalField(max_digits=10, decimal_places=2, validators=[MinValueValidator(Decimal("0.01"))])
    is_available = models.BooleanField(default=True)
    image = models.URLField(max_length=200, blank=True)
    is_veg = models.BooleanField(default=False)
    created = models.TimeField(auto_now_add=True)
    updated = models.TimeField(auto_now=True)

    # Managers
    objects = models.Manager()
    available = AvailabilityManager()
    tags = TaggableManager()

    class Meta:
        ordering = ("-is_available", "name",)

    def __str__(self):
        return f"FoodTemplate: {self.name}"
