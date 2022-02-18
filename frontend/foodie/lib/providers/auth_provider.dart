// import 'dart:convert';
// import 'dart:async';

// import 'package:flutter/widgets.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;


// class Auth with ChangeNotifier{
//   String? _token;
//   String? _userId;
//   String? get token{
//     return _token;
//   }
//   String? get userId{
//     return _userId;
//   }
//   bool get isAuth{
//     return token != null;
//   }
//   Future<void> authenticate() async{
//     final prefs = await SharedPreferences.getInstance();
//     final userData = json.encode(
//       {
//         'token':_token,
//         'userId':_userId,
//       }
//     );
    
//     prefs.setString('userData',userData);
//     if(!prefs.containsKey('token') || !prefs.containsKey('userId')){
//       return;
//     }
//     _token = prefs.getString('token');
//     _userId = prefs.getString('userId');
//     notifyListeners();

//   }
//   Future<bool> tryAutoLogin() async{
//     final prefs =await SharedPreferences.getInstance();
//     if(!prefs.containsKey('userData'))
//     {
//       return false;
//     }
//     if(prefs.containsKey('token') && prefs.containsKey('userId'))
//     final extractedUserData = json.decode(prefs.getString('userData')) as Map<String,Object>;
//     _token = extractedUserData['token'];
//     _userId = extractedUserData['userId'];
//     return true;
  

// }
//   Future<void> logout()async {
//     _token = null;
//     _userId = null;
//     notifyListeners();
//     final prefs = await SharedPreferences.getInstance();
//     prefs.remove('userData');
//   }
// }