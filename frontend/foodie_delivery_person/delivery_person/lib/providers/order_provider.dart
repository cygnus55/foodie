import 'dart:convert';
import 'dart:async';
// import 'dart:ffi';
// import 'dart:html';

import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../models/httpexception.dart';

class Order with ChangeNotifier(){
  
  Future <void> getorder() async{
    try{
      final prefs = await SharedPreferences.getInstance();
      print('pref is${prefs.getString('token')}'); 
      var url = Uri.http('','');
      final http.Response response = await http.get(url,``);
      }
      catch(error){
        throw error;
      }
}}