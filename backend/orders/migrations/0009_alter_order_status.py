# Generated by Django 4.0.2 on 2022-04-05 06:18

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('orders', '0008_order_khalti_token_order_payment_method_and_more'),
    ]

    operations = [
        migrations.AlterField(
            model_name='order',
            name='status',
            field=models.CharField(choices=[('Placed', 'Placed'), ('Verified', 'Verified'), ('Accepted', 'Accepted'), ('On the way to restaurant', 'On the way to restaurant'), ('Processing', 'Processing'), ('Picking', 'Picking'), ('On the way', 'On the way'), ('Delivered', 'Delivered'), ('Cancelled', 'Cancelled')], default='Placed', max_length=100),
        ),
    ]
