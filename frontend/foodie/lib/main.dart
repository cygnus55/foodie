import 'package:flutter/material.dart';
import 'package:foodie/providers/cart_provider.dart';
import 'package:foodie/providers/restaurant_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:khalti_flutter/khalti_flutter.dart';

import './screens/restaurant_detail_screen.dart';
import './screens/login_screen.dart';
import './screens/tab_screen.dart';
import './screens/otpverification_screen.dart';
import './screens/splash_screen.dart';
import './screens/personaldetails_screen.dart';
import './screens/food_detail_screen.dart';
import './screens/delivery_confirm_screen.dart';
import './screens/map_screen.dart';
import './screens/edit_profile.dart';

import './providers/restaurants_provider.dart';
import './providers/food_provider.dart';
import './providers/auth_provider.dart';
import './providers/foods_provider.dart';
import './providers/profile_screen_provider.dart';

import './color.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

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
        ChangeNotifierProxyProvider<Auth, Profile>(
          create: (ctx) => Profile('_'),
          update: (ctx, auth, previousAuth) => Profile(auth.getauthToken),
        ),
        ChangeNotifierProvider.value(
          value: Food(),
        ),
        ChangeNotifierProvider(create: (context) => Foods()),
        ChangeNotifierProvider(create: (context) => Restaurants()),
        ChangeNotifierProvider(create: (context) => Cart()),
        ChangeNotifierProvider(create: (context) => Restaurant()),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) {
          return KhaltiScope(
            publicKey: "test_public_key_90985e3ff8ea41d2ae11c7c5addf7a9c",
            builder: (context, navigatorKey) {
              return MaterialApp(
                navigatorKey: navigatorKey,
                supportedLocales: const [
                  Locale('en', 'US'),
                  Locale('ne', 'NP'),
                ],
                localizationsDelegates: const [
                  KhaltiLocalizations.delegate,
                ],
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
                  FoodDetailScreen.routeName: (ctx) => const FoodDetailScreen(),
                  RestaurantDetailScreen.routeName: (ctx) =>
                      const RestaurantDetailScreen(),

                  DeliveryConfirmScreen.routeName: (ctx) =>
                      const DeliveryConfirmScreen(),
                  MapScreen.routeName: (ctx) => MapScreen(),
                  EditProfileScreen.routeName: (ctx) => EditProfileScreen()
                },
              );
            },
          );
        },
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
