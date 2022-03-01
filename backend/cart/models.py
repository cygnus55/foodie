import imp
from statistics import mode
from django.db import models

from customers.models import Customer
from foods.models import Food

# Create your models here.

class Cart(models.Model):
    customer = models.OneToOneField(Customer, related_name="cart", on_delete=models.CASCADE)
    created = models.TimeField(auto_now_add=True)
    updated = models.TimeField(auto_now=True)

    class Meta:
        ordering = ('-created', '-customer')

    @property
    def total_amount(self):
        return sum(item.cost for item in self.items.all())
    
    def __str__(self):
        return f"Cart for customer {self.customer.user.full_name}"


class CartItem(models.Model):
    cart = models.ForeignKey(Cart, on_delete=models.CASCADE, related_name="items")
    food = models.ForeignKey(Food, on_delete=models.CASCADE)
    quantity = models.PositiveIntegerField(default=0)
    price = models.DecimalField(max_digits=10, decimal_places=2)
    created = models.TimeField(auto_now_add=True)
    updated = models.TimeField(auto_now=True)

    class Meta:
        unique_together = ('cart', 'food')

    @property
    def cost(self):
        return round(self.price * self.quantity, 2)
    
    # @property
    # def food_name(self):
    #     return self.food.name
