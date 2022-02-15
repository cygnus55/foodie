import 'package:flutter/material.dart';

import './screens/login_screen.dart';
import './screens/tab_screen.dart';
import './screens/profile_screen.dart';

import './color.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Foodie APP',
        theme: ThemeData(
          primarySwatch: buildMaterialColor(const Color(0xFFD42323)),
        ),
        // home: const MyHomePage(title: 'Foodie'),
        routes: {
          '/': (ctx) => const ProfileScreen(),
          TabScreen.routeName: (ctx) => const TabScreen(),
        });
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
