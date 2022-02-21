import 'package:flutter/material.dart';
import 'package:foodie/providers/restaurants_provider.dart';
import 'package:provider/provider.dart';

import './screens/login_screen.dart';
import './screens/tab_screen.dart';
import './screens/otpverification_screen.dart';
import './screens/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './screens/personaldetails_screen.dart';

import './providers/food_provider.dart';
import './providers/auth_provider.dart';
import './providers/foods_provider.dart';

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
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProvider.value(
          value: Food(),
        ),
        // ChangeNotifierProvider(create: (context) => Foods()),
        ChangeNotifierProvider(create: (context) => Restaurants()),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Foodie APP',
            theme: ThemeData(
              primarySwatch: buildMaterialColor(const Color(0xFFD42323)),
              iconTheme: const IconThemeData(color: Colors.black),
              dividerColor: Colors.black,
            ),
            home: auth.isAuth
                ? const TabScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, authResltSnapsot) =>
                        authResltSnapsot.connectionState ==
                                ConnectionState.waiting
                            ? const SplashScreen()
                            : const LoginScreen()),
            // home: const MyHomePage(title: 'Foodie'),
            routes: {
              // '/': (ctx) => const LoginScreen(),
              LoginScreen.routeName: (ctx) => const LoginScreen(),
              // SplashScreen.routeName: (ctx) => const SplashScreen(),
              TabScreen.routeName: (ctx) => const TabScreen(),
              PersonalDetails.routeName: (ctx) => const PersonalDetails(),
              OtpVerificationScreen.routeName: (ctx) =>
                  const OtpVerificationScreen(),
            }),
      ),
    );
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
