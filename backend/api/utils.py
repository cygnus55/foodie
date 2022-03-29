import copy
from dis import dis
from itertools import permutations
from random import choices

from geopy.geocoders import Nominatim
from geopy import distance

from restaurants.models import Restaurant


def get_delivery_location(lat, lng):
    geolocater = Nominatim(user_agent="orders")
    location = geolocater.reverse(f"{lat}, {lng}")
    return [lat, lng, location.address]


def calculate_distance(coords1:list, coords2:list):
    for i in range(2):
        coords1[i] = float(coords1[i])
        coords2[i] = float(coords2[i])
    return distance.distance(coords1, coords2).km


def get_delivery_charge(cus, restaurant_ids):
    loc = []
    for restaurant_id in restaurant_ids:
        restaurant = Restaurant.objects.get(id=restaurant_id)
        loc.append([restaurant.location[0], restaurant.location[1], restaurant_id])
    if len(loc) == 1:
        distance = calculate_distance(cus, loc[1])
        print(distance)
        return get_restaurant_charge(calculate_distance(cus, loc[1]))
    
    else:
        perm = permutations(loc)
        choices = []
        for l in perm:
            choices.append(list(l))
        for c in choices:
            # insert to index 0
            c.insert(0, cus)
        
        distance_list = []
        for choice in choices:
            distance = 0
            for j in range(1, len(choice)):
                distance += calculate_distance(choice[j-1][:2], choice[j][:2])
            distance_list.append(distance)
        min_distance = min(distance_list)
        return get_restaurant_charge(min_distance)
                

    
def get_restaurant_charge(min_distance):
    charge = 0
    if min_distance <= 1:
        charge += 100
    elif min_distance <= 5:
        charge += 100 + (min_distance - 1) * 20
    else:
        charge += 100 + (min_distance - 1) * 20 + (min_distance - 5) * 10
    return round(charge, 2)