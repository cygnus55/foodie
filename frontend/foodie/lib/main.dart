import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/home_screen.dart';
import './screens/login_screen.dart';
import './screens/tab_screen.dart';
// import './screens/profile_screen.dart';
import './screens/otpverification_screen.dart';
import './screens/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './providers/food_provider.dart';
import './providers/auth_provider.dart';

import './color.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
      // ChangeNotifierProvider.value(
      //   value: Auth(),
      // ),
        ChangeNotifierProvider.value(
          value: Food(),
        ),
      ],
      
      child: 
      // Customer<Auth>(
      //   builder: (ctx,auth,_) =>
         MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Foodie APP',
            theme: ThemeData(
              primarySwatch: buildMaterialColor(const Color(0xFFD42323)),
              iconTheme: const IconThemeData(color: Colors.black),
              dividerColor: Colors.black,
            ),
            //home:auth.isAuth ? TabScreen() : LoginScreen(),
            // home: const MyHomePage(title: 'Foodie'),
            routes: {
              '/': (ctx) => const SplashScreen(),
              TabScreen.routeName: (ctx) => const TabScreen(),
              LoginScreen.routeName: (ctx) => const LoginScreen(),
              OtpVerificationScreen.routeName: (ctx) =>
                  const OtpVerificationScreen(),
              HomeScreen.routeName: (ctx) => const HomeScreen(),
            }),
      )
    // ,)
    ;
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: const Center(
        child: Text(
          'This is Home Page',
        ),
      ),
    );
  }
}
