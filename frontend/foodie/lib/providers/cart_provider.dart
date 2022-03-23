import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import './auth_provider.dart';

class Cart with ChangeNotifier {
  String? totalPrice;
  String? restaurantname;
  String? restaurantid;
  List<CartItem>? _items;
  List<CartItem> get items {
    return [...?_items];
  }

  double get totalAmount {
    var total = 0.0;
    for (var restaurant in _items!) {
      for (var element in restaurant.foodlist!) {
        total = total + element.quantity! * double.parse(element.price!);
      }
    }
    return total;
  }

  int get total {
    var sum = 0;
    for (var restaurant in items) {
      for (var element in restaurant.foodlist!) {
        sum = sum + 1;
      }
    }
    print(sum);

    return sum;
  }

  Future<void> cartItems(BuildContext context) async {
    try {
      var url = Uri.http('10.0.2.2:8000', 'cart/');
      http.Response response = await http.get(
        url,
        headers: {
          'Authorization': 'Token ' +
              Provider.of<Auth>(context, listen: false).getauthToken!,
        },
      );
      final data = json.decode(response.body) as Map<String, dynamic>;
      final List<CartItem> cart = [];
      final List<FoodItem> fooditem = [];
      data.forEach((key, value) {
        if (key == 'total_price') {
          totalPrice = value;
        }
        if (key == 'items') {
          var data1 = value as Map;
          data1.forEach((key, value) {
            restaurantid = key;
            var data2 = value as List;
            data2.forEach((element) {
              var data3 = element as Map;
              data3.forEach((key, value) {
                if (key == 'name') {
                  restaurantname = value;
                }
                if (key == 'items') {
                  var data4 = value as List;
                  data4.forEach((element) {
                    fooditem.add(
                      FoodItem(
                        id: element['id'],
                        quantity: element['quantity'],
                        price: element['price'],
                        name: element['food_name'],
                        foodid: element['food'],
                      ),
                    );
                  });
                  cart.add(CartItem(
                      restaurantname: restaurantname,
                      restaurantid: restaurantid,
                      foodlist: [...fooditem]));
                  fooditem.clear();
                }
              });
            });
          });
        }
      });
      _items = cart;
      notifyListeners();

      print(_items);
    } catch (e) {
      print(e);
    }
  }

  Future<void> addToCart(BuildContext context, int quantity, int foodId) async {
    var url = Uri.http('10.0.2.2:8000', 'cart/add/');
    http.Response response = await http.post(
      url,
      headers: {
        'Authorization':
            'Token ' + Provider.of<Auth>(context, listen: false).getauthToken!,
        'Content-Type': 'application/json'
      },
      body: json.encode({'quantity': quantity, 'food': foodId}),
    );
    notifyListeners();
    print(response.body);
  }

  Future<void> deletefood(BuildContext context, int cartId) async {
    try {
      var url = Uri.http('10.0.2.2:8000', 'cart/items/$cartId/');
      http.Response response = await http.delete(
        url,
        headers: {
          'Authorization':
              'Token ' + Provider.of<Auth>(context, listen: false).getauthToken!
        },
      );
      print(response.body);
    } catch (e) {
      print(e);
    }
  }

  Future<void> deletecart(BuildContext context) async {
    try {
      var url = Uri.http('10.0.2.2:8000', 'cart/');
      http.Response response = await http.delete(
        url,
        headers: {
          'Authorization':
              'Token ' + Provider.of<Auth>(context, listen: false).getauthToken!
        },
      );
      print(response.body);
    } catch (e) {
      print(e);
    }
  }

  Future<void> createorder(BuildContext context, String lat, String lng) async {
    try {
      var url = Uri.http('10.0.2.2:8000', 'orders/create/');
      List<Map> body = [];
      for (var restaurant in items) {
        for (var food in restaurant.foodlist!) {
          body.add({
            "food_id": food.foodid,
            "quantity": food.quantity,
            "price": food.price,
          });
        }
      }

      http.Response response = await http.post(
        url,
        headers: {
          'Authorization': 'Token ' +
              Provider.of<Auth>(context, listen: false).getauthToken!,
          'Content-Type': 'application/json'
        },
        body: json.encode(
          {
            "method": "CART",
            "latitude": lat,
            "longitude": lng,
            "items": body,
          },
        ),
      );

      print(response.body);
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleterestaurant(
      BuildContext context, String restaurantId) async {
    try {
      var queryParameters = {
        'restaurant_id': restaurantId,
      };
      var url =
          Uri.http('10.0.2.2:8000', 'cart/clear/restaurant/', queryParameters);
      http.Response response = await http.get(
        url,
        headers: {
          'Authorization':
              'Token ' + Provider.of<Auth>(context, listen: false).getauthToken!
        },
      );
    } catch (e) {
      print(e);
    }
  }
}

class CartItem {
  String? restaurantname;
  String? restaurantid;
  List<FoodItem>? foodlist;

  CartItem({this.restaurantname, this.foodlist, this.restaurantid});
}

class FoodItem {
  int? id;
  int? quantity;
  String? price;
  String? name;
  int? foodid;

  FoodItem({
    this.id,
    this.quantity,
    this.price,
    this.name,
    this.foodid,
  });
}
