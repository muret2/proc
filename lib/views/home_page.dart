import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/cart_page.dart';
import 'package:flutter_application_1/views/orders_page.dart';
import 'package:flutter_application_1/views/profile_page.dart';
import 'package:flutter_application_1/views/shop_page.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    const ShopPage(),
    const CartPage(),
    const OrdersPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: GNav(
          color: Colors.grey[500],
          activeColor: Colors.grey[800],
          tabActiveBorder: Border.all(color: Colors.white),
          tabBackgroundColor: Colors.grey.shade300,
          mainAxisAlignment: MainAxisAlignment.center,
          tabBorderRadius: 16,
          onTabChange: (value) => navigateBottomBar(value),
          tabs: const [
            GButton(icon: Icons.home, text: 'Shop'),
            GButton(icon: Icons.shopping_cart, text: 'Cart'),
            GButton(icon: Icons.shopping_bag_rounded, text: 'Orders'),
            GButton(icon: Icons.person, text: 'Profile'),
          ],
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Padding(
              padding: EdgeInsets.only(left: 12.0),
              child: Icon(Icons.menu),
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => Get.offAllNamed('/'),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                DrawerHeader(child: Image.asset('assets/logo.jpg')),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: ListTile(
                    leading: const Icon(Icons.home, color: Colors.amber),
                    title: const Text(
                      'HOME',
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      navigateBottomBar(0);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: ListTile(
                    leading: const Icon(Icons.info, color: Colors.amber),
                    title: const Text(
                      'ABOUT',
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(25),
              child: ListTile(
                leading: const Icon(Icons.logout, color: Colors.amber),
                title: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () => Get.offAllNamed('/'),
              ),
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}
