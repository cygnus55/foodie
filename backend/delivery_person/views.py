from hashlib import md5
import random
import string

from django.shortcuts import redirect, render
from django.template.loader import render_to_string
from django.utils.html import strip_tags
from django.core.mail import send_mail
from django.contrib import messages

from delivery_person.forms import DeliveryPersonForm
from accounts.models import User
from delivery_person.models import DeliveryPerson

def register(request):
    if request.method == 'POST':
        form = DeliveryPersonForm(request.POST)
        if form.is_valid():
            full_name = form.cleaned_data.get('full_name')
            phone_no = form.cleaned_data.get('phone_number')
            username = form.cleaned_data.get('username')
            email = form.cleaned_data.get('email')
            try:
                user = User.objects.create(
                    full_name=full_name,
                    mobile=phone_no,
                    username=username,
                    email=email,
                    is_delivery_person=True,
                    is_verified = True
                )
                user.set_password(phone_no)
                user.save()
            except Exception as e:
                messages.error(request, e)
                return render(request, 'delivery_person/register.html', {'form': form})

            strg = user.full_name.lower()
            strg.join(random.choice(string.ascii_letters) for i in range(10))
            digest = md5(strg.encode("utf-8")).hexdigest()

            profile_picture = f"https://www.gravatar.com/avatar/{digest}?d=retro"

            DeliveryPerson.objects.create(user=user, profile_picture=profile_picture)

            # send email
            subject = "Welcome to Foodie"
            html_message = render_to_string('delivery_person/account_details_email.html', {"user": user})
            plain_message = strip_tags(html_message)
            from_email = 'Foodie Adminstrative <foodexpressnepal@gmail.com>'
            to = user.email

            send_mail(subject, plain_message, from_email, [to], html_message=html_message, fail_silently=False)
            
            messages.success(request, f"Account created for delivery person {user.full_name}.")
            return redirect('admin:delivery_person_deliveryperson_changelist')
    else:
        form = DeliveryPersonForm()
    return render(request, 'delivery_person/register.html', {'form': form})