import 'dart:convert';
import 'dart:async';
// import 'dart:ffi';
// import 'dart:html';

import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../models/httpexception.dart';

class Order with ChangeNotifier {
  final List _orderId=[];
  List get orderId {
    return [..._orderId];
  }

  List<OrderItem> _items = [];
  Future<void> getorder() async {
    try {
      _orderId.clear();
      final prefs = await SharedPreferences.getInstance();
      print('for order pref is${prefs.getString('token')}');
      var url = Uri.http('10.0.2.2:8000', 'delivery-person/new-orders/');
      final http.Response response = await http.get(
        url,
        headers: {
          'Authorization': 'Token ' + prefs.getString('token')!,
        },
      );
      print(response);
      final data = json.decode(response.body) as List;
      final List<FoodItem> fooditem = [];
      data.forEach((Element) {
        print(Element['order_id']);
        _orderId.add(Element['order_id']);
      });
      if (_orderId.isEmpty){
        _orderId.add('Nothing to show');
      }
      notifyListeners();
    } catch (error) {
      throw HttpException("Couldn't get the order");
    }
  }
}

class OrderItem {
  String? restaurantname;
  String? restaurantid;
  List<FoodItem>? foodlist;

  OrderItem({this.restaurantname, this.foodlist, this.restaurantid});
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
