from django.db import models
from django_better_admin_arrayfield.models.fields import ArrayField

from customers.models import Customer
from foods.models import Food

# Create your models here.




class Order(models.Model):
    STATUS_CHOICES = [
        ('Placed', 'Placed'),
        ('Verified', 'Verified'),
        ('Processing', 'Processing'),
        ('Picking', 'Picking'),
        ('On the way', 'On the way'),
        ('Delivered', 'Delivered'),
        ('Cancelled', 'Cancelled'),
    ]

    customer = models.ForeignKey(Customer, related_name='order', on_delete=models.CASCADE)
    delivery_location = ArrayField(models.CharField(max_length=500, blank=True), size=3)
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='Placed')
    created = models.DateTimeField(auto_now_add=True)
    updated = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ('created',)

    def __str__(self):
        return f'Order {self.id} placed by customer {self.customer.user.full_name}'
    
    @property
    def total_amount(self):
        return sum(item.cost for item in self.items.all())
    

class OrderItem(models.Model):
    food = models.ForeignKey(Food, related_name='items', on_delete=models.CASCADE)
    order = models.ForeignKey(Order, related_name='items', on_delete=models.CASCADE)
    quantity = models.PositiveIntegerField(default=1)
    price = models.DecimalField(max_digits=10, decimal_places=2)
    created = models.DateTimeField(auto_now_add=True)
    updated = models.DateTimeField(auto_now=True)

    class Meta:
        unique_together = ('order', 'food')
    
    @property
    def cost(self):
        return round(self.price * self.quantity, 2)