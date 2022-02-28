from django.db import models
from django.core.validators import MaxValueValidator, MinValueValidator
from decimal import Decimal

from taggit.managers import TaggableManager

from restaurants.models import Restaurant


class AvailabilityManager(models.Manager):
    """ Filter the objects on the basis of availability. """
    def get_queryset(self):
        return super().get_queryset().filter(is_available=True)


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
    created = models.TimeField(auto_now_add=True)
    updated = models.TimeField(auto_now=True)

    # Managers
    objects = models.Manager()
    available = AvailabilityManager()
    tags = TaggableManager()

    class Meta:
        ordering = ("-is_available", "-discount_percent", "name",)

    def __str__(self):
        return f"Food: {self.name}"

    @property
    def selling_price(self):
        return self.price - (self.price * self.discount_percent/100)


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