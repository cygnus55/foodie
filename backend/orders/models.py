from django.db import models
from django.db.models import Q
from django_better_admin_arrayfield.models.fields import ArrayField

from customers.models import Customer
from foods.models import Food

# Create your models here.


class UnacceptedOrderManager(models.Manager):
    """ Filter the objects on the basis of acceptance by delivery person."""
    def get_queryset(self):
        return super().get_queryset().filter(Q(status="Placed") | Q(status="Verified"))

class Order(models.Model):
    STATUS_CHOICES = [
        ('Placed', 'Placed'),
        ('Verified', 'Verified'),
        ('Accepted', 'Accepted'),
        ('On the way to restaurant', 'On the way to restaurant'),
        ('Processing', 'Processing'),
        ('Picking', 'Picking'),
        ('On the way', 'On the way'),
        ('Delivered', 'Delivered'),
        ('Cancelled', 'Cancelled'),
    ]

    PAYMENT_METHOD_CHOICES = [
        ('COD', 'COD'),
        ('Khalti', 'Khalti'),
    ]

    customer = models.ForeignKey(Customer, related_name='order', on_delete=models.CASCADE)
    delivery_location = ArrayField(models.CharField(max_length=500, blank=True), size=3)
    delivery_charge = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    payment_method = models.CharField(max_length=100, choices=PAYMENT_METHOD_CHOICES, default='COD')
    khalti_token = models.CharField(max_length=100, blank=True)
    status = models.CharField(max_length=100, choices=STATUS_CHOICES, default='Placed')
    created = models.DateTimeField(auto_now_add=True)
    updated = models.DateTimeField(auto_now=True)

    objects = models.Manager()
    unaccepted = UnacceptedOrderManager()

    class Meta:
        ordering = ('created',)

    def __str__(self):
        return f'Order {self.id} placed by customer {self.customer.user.full_name}'

    @property
    def order_id(self):
        return f'{self.created.strftime("%Y%m%d")}-{self.id}'
    
    def distance(self, lat, lng):
            from geopy.distance import geodesic
            location = self.delivery_location
            return geodesic((location[0], location[1]), (lat, lng)).km

    @property
    def total_amount(self):
        return round(sum(item.cost for item in self.items.all()) + self.delivery_charge, 2)
    

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