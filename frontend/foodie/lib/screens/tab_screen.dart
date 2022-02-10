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
    const OfferScreen(),
  ];

  int _selectedTabsIndex = 0;

  void _selectTab(int index) {
    setState(() {
      _selectedTabsIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              Icons.local_offer,
              size: 30,
            ),
            label: 'search',
          ),
        ],
      ),
    );
  }
}
