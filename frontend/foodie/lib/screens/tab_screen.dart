import 'package:flutter/material.dart';
import './home_screen.dart';
import './search_screen.dart';
import './cart_screen.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({Key? key}) : super(key: key);

  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  final List _tabs = [
    const HomeScreen(),
    const CartScreen(),
    const SearchScreen(),
  ];

  int _selectedTabsIndex = 0;
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  void _selectTab(int index) {
    if (index == 3) {
      _drawerKey.currentState?.openDrawer();
    } else {
      setState(() {
        _selectedTabsIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      drawer: const Drawer(),
      body: _tabs[_selectedTabsIndex],
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: false,
        showSelectedLabels: false,
        onTap: _selectTab,
        currentIndex: _selectedTabsIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
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
              Icons.search,
              size: 30,
            ),
            label: 'search',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.menu,
              size: 30,
            ),
            label: 'menu',
          ),
        ],
      ),
    );
  }
}
