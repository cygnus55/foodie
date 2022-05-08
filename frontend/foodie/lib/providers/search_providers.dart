import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:foodie/providers/auth_provider.dart';
import './restaurant_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import './food_provider.dart';

class Search with ChangeNotifier {
  List<Food> _items = [];
  List<Food> get items {
    return [..._items];
  }

  List<Restaurant> _item = [];
  List<Restaurant> get item {
    return [..._item];
  }

  Future<void> searchfoods(BuildContext context, value) async {
    try {
      var url = Uri.http('10.0.2.2:8000', 'api/search/', {'query': value});
      late http.Response response;
      response = await http.get(url);
      final data = json.decode(response.body) as Map<String, dynamic>;

      final List<Food> foods = [];
      final List<Restaurant> restaurants = [];

      data.forEach((key, value) {
        if (key == 'foods') {
          var data = value as List;
          for (var element in data) {
            var restaurant = element['restaurant'] as Map;
            var user = restaurant['user'] as Map;
            foods.add(
              Food(
                id: element['id'],
                discountPercent: element['discount_percent'],
                description: element['description'],
                image: element['image'],
                isVeg: element['is_veg'],
                rating: double.parse(element['average_ratings']),
                ratingCount: element['ratings_count'],
                name: element['name'],
                price: element['price'],
                tags: element['tags'],
                sellingPrice: element['selling_price'],
                isAvailable: element['is_available'],
                isFavourite: element['is_favourite'],
                restaurant: Restaurant(
                  id: restaurant['id'],
                  closeTime: restaurant['close_hour'],
                  description: restaurant['description'],
                  logo: restaurant['logo'],
                  facebookLink: restaurant['facebook_link'],
                  isAvailable: restaurant['is_available'],
                  openTime: restaurant['open_hour'],
                  websiteLink: restaurant['website_link'],
                  isFavourite: restaurant['is_favourite'],
                  name: user['full_name'],
                  openStatus: restaurant['open_status'],
                ),
              ),
            );
          }
        } else if (key == 'restaurants') {
          var data = value as List;
          data.forEach(
            (element) {
              var restaurant = element['user'] as Map;
              restaurants.add(
                Restaurant(
                  id: element['id'],
                  closeTime: element['close_hour'],
                  description: element['description'],
                  logo: element['logo'],
                  facebookLink: element['facebook_link'],
                  isAvailable: element['is_available'],
                  openTime: element['open_hour'],
                  websiteLink: element['website_link'],
                  name: restaurant['full_name'],
                  rating: double.parse(element['average_ratings']),
                  ratingCount: element['ratings_count'],
                  address: element['address'],
                  openStatus: element['open_status'],
                  isFavourite: element['is_favourite'],
                ),
              );
            },
          );
        }
      });
      print(foods);
      print(restaurants);

      _items = foods;
      _item = restaurants;

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
