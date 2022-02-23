import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import './screens/otpverification_screen.dart';

Future<void> submitNumber(String phoneNumber, BuildContext context) async {
  try {
    var url = Uri.http('10.0.2.2:8000', 'accounts/send-otp/');
    // // ignore: unused_local_variable
    final http.Response response = await http.post(
      url,
      body: json.encode({
        'mobile': phoneNumber,
      }),
    );
    var status = response.statusCode;
    if (status == 200) {
      Navigator.of(context)
          .pushNamed(OtpVerificationScreen.routeName, arguments: phoneNumber);
    } else {}
  } catch (error) {
    rethrow;
  }
}
