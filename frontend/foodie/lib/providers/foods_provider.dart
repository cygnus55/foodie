import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:foodie/providers/restaurant_provider.dart';
import 'package:http/http.dart' as http;
import './food_provider.dart';

class Foods with ChangeNotifier {
  List<Food> _items = [
    // Food(
    //   id: 'f1',
    //   name: 'Chicken MOMO',
    //   description: 'this is chicken momo',
    //   price: 150,
    //   image:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a1/Momo_nepal.jpg/1200px-Momo_nepal.jpg',
    //   discountPercent: 10,
    //   isVeg: false,
    // ),
    // Food(
    //   id: 'f2',
    //   name: 'Veg MOMO',
    //   description: 'this is veg momo',
    //   price: 120,
    //   image:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a1/Momo_nepal.jpg/1200px-Momo_nepal.jpg',
    //   discountPercent: 10,
    //   isVeg: true,
    // ),
    // Food(
    //   id: 'f3',
    //   name: 'Chicken Chowmein',
    //   description: 'this is chicken chowmein',
    //   price: 150,
    //   image:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1e/Tallarin_Saltado_Peru.jpg/220px-Tallarin_Saltado_Peru.jpg',
    //   discountPercent: 10,
    //   isVeg: false,
    // ),
    // Food(
    //   id: 'f4',
    //   name: 'Veg Chowmein',
    //   description: 'this is Veg chowmein',
    //   price: 120,
    //   image:
    //       'https://upload.wikimedia.org/wikipedia/commons/d/d1/Chow_mein_1_by_yuen.jpg',
    //   discountPercent: 10,
    //   isVeg: false,
    // ),
  ];
  List<Food> get items {
    return [..._items];
  }

  void addFood(value) {
    _items.add(value);
    notifyListeners();
  }

  Food findById(int id) {
    return _items.firstWhere((food) => food.id == id);
  }

  Future<void> getfoods() async {
    try {
      var url = Uri.http('10.0.2.2:8000', 'foods/');
      http.Response response = await http.get(url);
      final data = json.decode(response.body) as List<dynamic>;
      final List<Food> foods = [];
      data.forEach(
        (element) {
          var restaurant = element['restaurant'] as Map;
          var user = restaurant['user'] as Map;
          foods.add(
            Food(
              id: element['id'],
              discountPercent: element['discount_percent'],
              description: element['description'],
              image: element['image'],
              isVeg: element['is_veg'],
              name: element['name'],
              price: element['price'],
              tags: element['tags'],
              sellingPrice: element['selling_price'],
              restaurant: Restaurant(
                  id: restaurant['id'],
                  closeTime: restaurant['close_hour'],
                  description: restaurant['description'],
                  logo: restaurant['logo'],
                  facebookLink: restaurant['facebook_link'],
                  isAvailable: restaurant['is_available'],
                  openTime: restaurant['open_hour'],
                  websiteLink: restaurant['website_link'],
                  name: user['full_name']),
            ),
          );
        },
      );
      _items = foods;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
