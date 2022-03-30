import 'package:delivery_person/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import './screens/login_screen.dart';
import './screens/splash_screen.dart';
import './screens/homepage_screen.dart';
import './screens/passwordchangescreen.dart';
import './providers/auth_provider.dart';
import 'color.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return  MultiProvider(providers: [
      ChangeNotifierProvider.value(
          value: Auth(),
        ),
    ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
         title: 'Delivery Person APP',
            theme: ThemeData(
              primarySwatch: buildMaterialColor(const Color(0xFFD42323)),
              iconTheme: const IconThemeData(color: Colors.black),
              dividerColor: Colors.black,
            ),
        home:auth.isAuth
                    ? const HomepageScreen()
                    : FutureBuilder(
                        future: auth.tryAutoLogin(),
                        builder: (ctx, authResltSnapsot) =>
                            authResltSnapsot.connectionState ==
                                    ConnectionState.waiting
                                ? const SplashScreen()
                                : const LoginScreen()),
        routes: {
          LoginScreen.routeName: (ctx) => const LoginScreen(),
          PasswordChangeScreen.routeName: (ctx) => const PasswordChangeScreen(),
          HomepageScreen.routeName: (ctx) => const HomepageScreen(),
        }
      )),
    );
  }
}
