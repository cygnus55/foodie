from django import forms


class RestaurantRegistrationForm(forms.Form):
    full_name = forms.CharField(max_length=100, required=True)
    phone_number = forms.CharField(max_length=20, required=True)
    email = forms.EmailField(required=False)
    open_hour = forms.TimeField(required=True)
    close_hour = forms.TimeField(required=True)