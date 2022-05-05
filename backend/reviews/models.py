from django.db import models
from django.core.validators import MaxValueValidator, MinValueValidator
from django.contrib.contenttypes.fields import GenericForeignKey
from django.contrib.contenttypes.models import ContentType

from customers.models import Customer


class Review(models.Model):
    customer = models.ForeignKey(
        Customer,
        related_name="review",
        on_delete=models.CASCADE
    )
    ratings = models.PositiveIntegerField(
        default=1,
        validators=[
            MaxValueValidator(5),
            MinValueValidator(1)
        ]
    )
    comment = models.TextField(blank=True)
    content_type = models.ForeignKey(ContentType, related_name="type", on_delete=models.CASCADE)
    object_id = models.PositiveIntegerField()
    content_object = GenericForeignKey("content_type", "object_id")
    created = models.TimeField(auto_now_add=True)
    updated = models.TimeField(auto_now=True)

    class Meta:
        unique_together = ("customer", "content_type", "object_id")

    def __str__(self):
        return f"Review: {self.customer.user.full_name} for {self.content_object}"
