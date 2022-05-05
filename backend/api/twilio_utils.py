import os
from twilio.rest import Client
from twilio.base.exceptions import TwilioRestException

account_sid = os.environ.get('TWILIO_ACCOUNT_SID')
auth_token = os.environ.get('TWILIO_AUTH_TOKEN')
verify_service_sid = os.environ.get('TWILIO_VERIFY_SERVICE_SID')

client = Client(account_sid, auth_token)
verify = client.verify.services(verify_service_sid)


def send(phone):
    # verify.verifications.create(to=phone, channel='sms')
    print("OTP: 123456")


def check(phone, code):
    # try:
    #     result = verify.verification_checks.create(to=phone, code=code)
    # except TwilioRestException:
    #     return False
    # return result.status == 'approved'
    return code == "123456"


def send_sms(phone, message):
    try:
        client.messages.create(
            to=phone,
            from_=os.environ.get('TWILIO_PHONE_NUMBER'),
            body=message,
        )
    except:
        print(message)