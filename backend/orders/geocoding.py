from geopy.geocoders import Nominatim

def get_delivery_location(lat, lng):
    geolocater = Nominatim(user_agent="orders")
    location = geolocater.reverse(f"{lat}, {lng}")
    return [lat, lng, location.address]