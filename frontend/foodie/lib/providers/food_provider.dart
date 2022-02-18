import 'package:flutter/material.dart';

class Food with ChangeNotifier {
 
 
 
  void addFood() {
    notifyListeners();
  }
}
