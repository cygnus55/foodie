import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:http/http.dart' as http;

import '../screens/otpverification_screen.dart';
import '../screens/tab_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const routeName = '/login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String phoneNumber = '';
  final numbercontroller = TextEditingController();
  Future<void> submit() async {
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
    }
    print(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.33,
                    child: Image.asset(
                      'assets/images/login.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 40, 5, 0),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(3.0),
                          primary: Colors.white,
                          textStyle: const TextStyle(fontSize: 20),
                          backgroundColor: const Color(0xFF666565),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacementNamed(TabScreen.routeName);
                        },
                        child: const Text('Skip'),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              const Text(
                "Bringing Restaurants to you",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              const SizedBox(
                height: 30,
              ),
              Card(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      'Log In or Sign Up',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        child: IntlPhoneField(
                          decoration: const InputDecoration(
                            labelText: 'Enter Phone Number',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(),
                            ),
                          ),
                          initialCountryCode: 'NP',
                          onChanged: (phone) {
                            numbercontroller.text = phone.completeNumber;
                            // ignore: avoid_print
                            phoneNumber = phone.completeNumber;
                            print(phone.completeNumber);
                          },
                        )),
                    Container(
                      padding: const EdgeInsets.all(15),
                      width: double.infinity,
                      child: ElevatedButton(
                          // ignore: avoid_print
                          onPressed: () {
                            submit();
                          },
                          child: const Padding(
                              padding: EdgeInsets.all(15),
                              child: Text(
                                'Continue',
                                style: TextStyle(fontSize: 20),
                              ))),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
                elevation: 5,
              ),
              const SizedBox(
                height: 15,
              ),
              SignInButton(
                Buttons.GoogleDark,
                onPressed: () {},
              ),
              SignInButton(
                Buttons.Facebook,
                onPressed: () {},
              ),
              const SizedBox(
                height: 15,
              ),
              const Text('By continuing you woluld agree to our',
                  style: TextStyle(
                    color: Color(0xCDCDCDCD),
                  )),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Text('Term of service ',
                      style: TextStyle(
                          color: Color(0xCDCDCDCD),
                          decoration: TextDecoration.underline)),
                  Text('Privacy Policy',
                      style: TextStyle(
                          color: Color(0xCDCDCDCD),
                          decoration: TextDecoration.underline)),
                  Text('Contend Policy',
                      style: TextStyle(
                          color: Color(0xCDCDCDCD),
                          decoration: TextDecoration.underline)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
