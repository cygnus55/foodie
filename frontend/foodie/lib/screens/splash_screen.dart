import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import './login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void test() {
    Future.delayed(
        const Duration(seconds: 15),
        () =>
            Navigator.of(context).pushReplacementNamed(LoginScreen.routeName));
  }

  @override
  void initState() {
    super.initState();
    test();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png'),
            const SpinKitThreeBounce(
              color: Color(0xFFCB3737),
              size: 30.0,
            ),
          ],
        ),
      ),
    );
  }
}
