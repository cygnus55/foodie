from hashlib import md5
import random
import string

from django.shortcuts import redirect, render
from django.template.loader import render_to_string
from django.utils.html import strip_tags
from django.core.mail import send_mail
from django.contrib import messages
from django.contrib.admin.views.decorators import staff_member_required
from django.contrib.auth.decorators import login_required
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from rest_framework.authentication import TokenAuthentication
from rest_framework.response import Response
from rest_framework.status import HTTP_400_BAD_REQUEST, HTTP_200_OK

from delivery_person.forms import DeliveryPersonForm
from accounts.models import User
from delivery_person.models import DeliveryPerson
from delivery_person.custompermissions import IsCurrentUserOwner
from api import customauthentication, custompermissions
from delivery_person.serilizers import DeliveryPersonProfileSerializer


@staff_member_required
@login_required
def register(request):
    if request.method == 'POST':
        form = DeliveryPersonForm(request.POST)
        if form.is_valid():
            full_name = form.cleaned_data.get('full_name')
            phone_no = form.cleaned_data.get('phone_number')
            email = form.cleaned_data.get('email')
            try:
                user = User.objects.create(
                    full_name=full_name,
                    mobile=phone_no,
                    username=phone_no,
                    email=email,
                    is_delivery_person=True,
                    is_verified = True
                )
                password = str(phone_no)
                if password.startswith("+977"):
                    password = phone_no[4:]
                user.set_password(password)
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


class ChangePassword(APIView):
    permission_classes = [
        IsAuthenticated,
        custompermissions.AllowOnlyDeliveryPerson,
        IsCurrentUserOwner
    ]
    authentication_classes = [
        TokenAuthentication,
        customauthentication.CsrfExemptSessionAuthentication
    ]


    def post(self, request, format=None):
        user = request.user
        password = request.data.get('password')
        user.set_password(password)
        user.save()
        return Response({"success": "Password changed successfully."},status=HTTP_200_OK)


class DeliveryPersonProfile(APIView):
    permission_classes = [
        IsAuthenticated,
        custompermissions.AllowOnlyDeliveryPerson,
        IsCurrentUserOwner,
    ]
    authentication_classes = [
        TokenAuthentication,
        customauthentication.CsrfExemptSessionAuthentication
    ]

    def get(self, request, format=None):
        delivery_person = request.user.delivery_person
        serializers = DeliveryPersonProfileSerializer(delivery_person)
        return Response(serializers.data, status=HTTP_200_OK)

    def put(self, request, format=None):
        delivery_person = request.user.delivery_person
        serializer = DeliveryPersonProfileSerializer(delivery_person, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=HTTP_200_OK)
        return Response(serializer.errors, status=HTTP_400_BAD_REQUEST)

    def patch(self, request, format=None):
        delivery_person = request.user.delivery_person
        serializer = DeliveryPersonProfileSerializer(
            delivery_person, data=request.data, partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=HTTP_200_OK)
        return Response(serializer.errors, status=HTTP_400_BAD_REQUEST)