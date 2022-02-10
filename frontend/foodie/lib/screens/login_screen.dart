import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.33,
          child: Image.asset('assets/images/login.png', fit: BoxFit.cover),
        ),
        const SizedBox(
          height: 25,
        ),
        const Text(
          "Bringing Restaurant to you",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ],
    ));
  }
}
