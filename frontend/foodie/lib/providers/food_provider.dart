import 'package:flutter/material.dart';
import './restaurant_provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import './auth_provider.dart';

class Food with ChangeNotifier {
  int? id;
  String? name;
  String? description;
  String? price;
  String? sellingPrice;
  String? image;
  bool? isAvailable;
  int? discountPercent;
  Restaurant? restaurant;
  bool? isFavourite;

  double? rating;
  int? ratingCount;

  List? tags;
  bool? isVeg;

  Food({
    this.id,
    this.name,
    this.description,
    this.price,
    this.image,
    this.discountPercent,
    this.isVeg,
    this.restaurant,
    this.tags,
    this.sellingPrice,
    this.rating,
    this.ratingCount,
    this.isFavourite,
    this.isAvailable,
  });

  Future<void> toggleFav(BuildContext context, int foodid) async {
    try {
      var url = Uri.http('10.0.2.2:8000', 'favourites/foods/$foodid');
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

  void addFood() {
    notifyListeners();
  }
}
