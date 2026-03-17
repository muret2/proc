import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/bottom_nav_bar.dart';
import 'package:flutter_application_1/views/orders_page.dart';
import 'package:flutter_application_1/views/profile_page.dart';
import 'package:get/get.dart';

import 'cart_page.dart';
import 'shop_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Controls which page is shown
  int _selectedIndex = 0;

  void navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Pages to display
  final List<Widget> _pages = [
    const ShopPage(),
    const CartPage(),
    const OrdersPage(), // fixed: was OdersPage
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      bottomNavigationBar: MyBottomNavBar(
        onTabChange: (index) => navigateBottomBar(index),
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
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
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
                // Logo
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
                      Navigator.pop(context); // close drawer
                      navigateBottomBar(0); // go to shop
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

            // Logout at bottom of drawer
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
