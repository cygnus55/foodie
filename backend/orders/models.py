import decimal

from django.db import models
from django.db.models import Q
from django_better_admin_arrayfield.models.fields import ArrayField
from django.template.loader import render_to_string
from django.utils.html import strip_tags
from django.core.mail import send_mail

from customers.models import Customer
from delivery_person.models import DeliveryPerson
from foods.models import Food


class UnacceptedOrderManager(models.Manager):
    """ Filter the objects on the basis of acceptancmodels.DecimalField(max_digits=10, decimal_places=2, default=0)e by delivery person."""
    def get_queryset(self):
        return super().get_queryset().filter(is_accepted=False)


class Order(models.Model):
    STATUS_CHOICES = [
        ('Placed', 'Placed'),
        ('Verified', 'Verified'),
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
    is_accepted = models.BooleanField(default=False)
    accepted_by = models.ForeignKey(DeliveryPerson, related_name='accepted_orders', on_delete=models.SET_NULL, null=True, blank=True)
    accepted_on = models.DateTimeField(blank=True, null=True)

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
            return round(geodesic((location[0], location[1]), (lat, lng)).km)

    @property
    def total_amount(self):
        return round(sum(item.cost for item in self.items.all()) + decimal.Decimal(self.delivery_charge), 2)
    
    @property
    def restaurants(self):
        return list(set([item.food.restaurant for item in self.items.all()]))
    
    def get_items(self, restaurant):
        return [item for item in self.items.all() if item.food.restaurant == restaurant]
    
    def send_mail_to_restaurants(self):
        subject = f'Order {self.order_id} has been placed'
        for restaurant in self.restaurants:
            items = self.get_items(restaurant)
            html_message = render_to_string('orders/restaurant_notify_mail.html', {"order": self, "restaurant": restaurant, "items": items})
            plain_message = strip_tags(html_message)
            from_email = 'Foodie Adminstrative <foodexpressnepal@gmail.com>'
            to = restaurant.user.email
            send_mail(subject, plain_message, from_email, [to], html_message=html_message, fail_silently=False)




class OrderItem(models.Model):
    food = models.ForeignKey(Food, related_name='items', on_delete=models.CASCADE)
    order = models.ForeignKey(Order, related_name='items', on_delete=models.CASCADE)
    quantity = models.PositiveIntegerField(default=1)
    price = models.DecimalField(max_digits=10, decimal_places=2)
    created = models.DateTimeField(auto_now_add=True)
    updated = models.DateTimeField(auto_now=True)

    class Meta:
        unique_together = ('order', 'food')

    def distance(self, lat, lng):
            from geopy.distance import geodesic
            location = self.food.restaurant.location
            return round(geodesic((location[0], location[1]), (lat, lng)).km)

    @property
    def cost(self):
        return round(self.price * self.quantity, 2)
