import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import './auth_provider.dart';

class Restaurant with ChangeNotifier {
  int? id;
  String? websiteLink;
  String? facebookLink;
  String? name;
  String? description;
  bool? isAvailable;
  String? openTime;
  double? rating;
  int? ratingCount;
  String? closeTime;
  String? logo;
  String? address;
  bool? openStatus;
  bool? isFavourite;
  // List? tags;

  Restaurant({
    this.address,
    this.id,
    this.websiteLink,
    this.facebookLink,
    this.name,
    this.description,
    this.isAvailable,
    this.openTime,
    this.closeTime,
    this.logo,
    this.rating,
    this.ratingCount,
    this.openStatus,
    this.isFavourite,
  });

  Future<void> toggleFav(BuildContext context, int restaurantid) async {
    try {
      var url =
          Uri.http('10.0.2.2:8000', 'favourites/restaurants/$restaurantid');
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
