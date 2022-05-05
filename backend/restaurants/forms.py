from django import forms
from django.contrib.auth.forms import PasswordChangeForm
from django.core.exceptions import ValidationError

from restaurants.models import Restaurant
from accounts.models import User


class RestaurantRegistrationForm(forms.Form):
    full_name = forms.CharField(max_length=250, required=True)
    phone_number = forms.CharField(max_length=20, required=True)
    email = forms.EmailField(required=False)
    open_hour = forms.TimeField(required=True)
    close_hour = forms.TimeField(required=True)

    def clean_close_hour(self):
        ''' Validate closing time to be greater than opening time. '''
        open_hour = self.cleaned_data.get('open_hour')
        close_hour = self.cleaned_data.get('close_hour')

        if open_hour >= close_hour:
            raise forms.ValidationError('Closing hour should be greater than opening hour!')

        return close_hour


class RestaurantNameUpdateForm(forms.ModelForm):
    class Meta:
        model = User
        fields = ["full_name"]

    def clean(self, *args, **kwargs):
        data = super().clean(*args, **kwargs)
        if not data.get("full_name"):
            raise ValidationError("Name cannot be empty!")
        return data


class RestaurantAccountUpdateForm(forms.ModelForm):
    class Meta:
        model = Restaurant
        fields = [
            "description", "open_hour", "close_hour",
            "website_link", "facebook_link", "is_available",
            "logo", "tags",
        ]


class CustomChangePasswordForm(PasswordChangeForm):
    pass
