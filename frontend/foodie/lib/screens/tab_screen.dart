import 'package:flutter/material.dart';
import 'package:foodie/providers/auth_provider.dart';
import 'package:provider/provider.dart';

import './login_screen.dart';
import './profile_screen.dart';
import './home_screen.dart';
import './offer_screen.dart';
import './cart_screen.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({Key? key, String? phoneNumber}) : super(key: key);
  static const routeName = '/tabs';

  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  bool _auth = false;
  List _tabs = [
    const HomeScreen(),
    const LoginScreen(),
  ];

  int _selectedTabsIndex = 0;

  void _selectTab(int index) {
    setState(() {
      _selectedTabsIndex = index;
    });
    if (!_auth) {
      if (index == 1) {
        Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
      } else {
        setState(() {
          _selectedTabsIndex = index;
        });
      }
    }
  }

  void _isAuth() {
    if (Provider.of<Auth>(context).isAuth) {
      setState(() {
        _auth = true;
        _tabs = [
          const HomeScreen(),
          const CartScreen(),
          const OfferScreen(),
          ProfileScreen()
        ];
      });
    } else {
      setState(() {
        _auth = false;
        _tabs = [
          const HomeScreen(),
          const LoginScreen(),
        ];
      });
    }
  }

  List<BottomNavigationBarItem> _list() {
    if (_auth) {
      return const [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            size: 30,
          ),
          label: 'home',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.shopping_cart,
            size: 30,
          ),
          label: 'cart',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.local_offer,
            size: 30,
          ),
          label: 'offer',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.person,
            size: 30,
          ),
          label: 'account',
        ),
      ];
    } else {
      return const [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            size: 30,
          ),
          label: 'home',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.person,
            size: 30,
          ),
          label: 'account',
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    _isAuth();
    return SafeArea(
      child: Scaffold(
        // extendBodyBehindAppBar: true,
        // drawer: const Drawer(),
        // appBar: AppBar(
        //   leading: Builder(builder: (context) {
        //     return IconButton(
        //       onPressed: () => Scaffold.of(context).openDrawer(),
        //       icon: const Icon(
        //         Icons.menu,
        //         size: 30,
        //       ),
        //     );
        //   }),
        //   backgroundColor: Colors.transparent,
        //   iconTheme: const IconThemeData(color: Colors.grey),
        //   elevation: 0,
        // ),
        body: _tabs[_selectedTabsIndex],
        bottomNavigationBar: BottomNavigationBar(
          showUnselectedLabels: false,
          showSelectedLabels: false,
          onTap: _selectTab,
          currentIndex: _selectedTabsIndex,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: _list(),
        ),
      ),
    );
  }
}
