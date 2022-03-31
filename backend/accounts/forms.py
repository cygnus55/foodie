from django import forms


class LoginForm(forms.Form):
    mobile = forms.CharField(
        widget=forms.TextInput(attrs={"class": "form-control"}),
        label="Mobile"
    )
    password = forms.CharField(widget=forms.PasswordInput(attrs={"class": "form-control"}))