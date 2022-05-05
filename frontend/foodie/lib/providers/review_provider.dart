import 'package:flutter/material.dart';

class Review with ChangeNotifier {
  String? comment;
  int? rating;
  String? name;
  Review({this.comment, this.rating, this.name});
}
