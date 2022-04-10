import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import './auth_provider.dart';

class Cart with ChangeNotifier {
  String? totalPrice;
  String? restaurantname;
  String? restaurantid;
  int? cartid;
  List<CartItem>? _items;
  RecentOrder? _order;
  RecentOrder get order {
    return _order!;
  }

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

  int get cartId {
    return cartid!;
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
        if (key == 'id') {
          cartid = value;
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
                  cart.add(
                    CartItem(
                      restaurantname: restaurantname,
                      restaurantid: restaurantid,
                      foodlist: [...fooditem],
                    ),
                  );
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

  Future<double> getDeliveryChargeFromcart(
      BuildContext context, String lat, String long) async {
    try {
      var url = Uri.http('10.0.2.2:8000', 'orders/delivery-charge/');
      var delivery_price = 0.0;
      http.Response response = await http.post(
        url,
        headers: {
          'Authorization': 'Token ' +
              Provider.of<Auth>(context, listen: false).getauthToken!,
          'Content-Type': 'application/json'
        },
        body: json.encode({'latitude': lat, 'longitude': long}),
      );
      print(response.body);
      final data = json.decode(response.body) as Map;
      data.forEach((key, value) {
        if (key == 'deliverty_charge') {
          delivery_price = value;
        }
      });
      return delivery_price;
    } catch (e) {
      rethrow;
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

  Future<void> createorderCOD(BuildContext context, String lat, String lng,
      String address, double deliveryCharge) async {
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
            "address": address,
            "items": body,
            "payment_method": "COD",
            "delivery_charge": deliveryCharge,
          },
        ),
      );
      await cartItems(context);
      final data = json.decode(response.body) as Map;
      List<OrderFood> food = [];
      RecentOrder recentorder;
      (data['items'] as List).forEach(
        (element) {
          food.add(
            OrderFood(
              cost: element['cost'],
              name: element['food_name'],
              price: element['price'],
              quantity: element['quantity'],
              restaurantname: element['restaurant_name'],
            ),
          );
        },
      );
      recentorder = RecentOrder(
        orderid: data['order_id'],
        acceptedby: data['accepted_by'],
        deliverycharge: data['delivery_charge'],
        deliverylocation: data['delivery_location'],
        food: food,
        isaccepted: data['is_accepted'],
        paymentmethod: data['payment_method'],
        status: data['status'],
        totalamount: data['total_amount'],
      );
      _order = recentorder;

      print(response.body);
    } catch (e) {
      print(e);
    }
  }

  Future<void> createorderkhalti(BuildContext context, String lat, String lng,
      String address, double deliveryCharge) async {
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
            "address": address,
            "items": body,
            "payment_method": "khalti",
            "delivery_charge": deliveryCharge
          },
        ),
      );
      await cartItems(context);

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

class OrderFood {
  int? quantity;
  String? price;
  String? name;
  String? cost;
  String? restaurantname;
  OrderFood(
      {this.quantity, this.cost, this.name, this.price, this.restaurantname});
}

class RecentOrder {
  String? orderid;
  String? totalamount;
  String? status;
  bool? isaccepted;
  List? deliverylocation;
  String? deliverycharge;
  String? paymentmethod;
  Map? acceptedby;
  List<OrderFood>? food;
  RecentOrder({
    this.acceptedby,
    this.deliverycharge,
    this.deliverylocation,
    this.food,
    this.isaccepted,
    this.orderid,
    this.paymentmethod,
    this.status,
    this.totalamount,
  });
}
