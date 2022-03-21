import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import './auth_provider.dart';

class Cart with ChangeNotifier {
  String? totalPrice;
  String? restaurantname;
  List<CartItem>? _items;
  List<CartItem> get items {
    return [...?_items];
  }

  String get totalAmount {
    return totalPrice!;
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
                      restaurantname: restaurantname, foodlist: [...fooditem]));
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
    print(response.body);
  }

  // void addItems(int id, String price, String name){
  //   if (_items!.containsKey(key)){

  //   }
  //   else{
  //     _items.putIfAbsent(key, ))

  //   }
  // }
}

class CartItem {
  String? restaurantname;
  List<FoodItem>? foodlist;

  CartItem({this.restaurantname, this.foodlist});
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
