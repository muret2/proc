import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/oders_page.dart';
import 'package:flutter_application_1/views/profile_page.dart';

import '../controllers/bottom_nav_bar.dart';
import 'cart_page.dart';
import 'shop_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //this selects index is to control the bottom nav bar
  int _selectedIndex = 0;

  //this method will update our selectedIndex

  void navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  //pages to display
  final List<Widget> _pages = [
    //Shop page
    const ShopPage(),

    //cart page
    const CartPage(),

    //oders page
    const OdersPage(),

    //profile page
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
            icon: Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Icon(Icons.menu),
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, "/login");
            },
            icon: Icon(Icons.logout),
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
                //logo
                DrawerHeader(child: Image.asset('logo.jpg')),
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: ListTile(
                    leading: Icon(Icons.home, color: Colors.amber),
                    title: Text('HOME', style: TextStyle(color: Colors.red)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: ListTile(
                    leading: Icon(Icons.info, color: Colors.amber),
                    title: Text('ABOUT', style: TextStyle(color: Colors.red)),
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, "/login");
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: ListTile(
                  leading: Icon(Icons.logout, color: Colors.amber),
                  title: Text('logout', style: TextStyle(color: Colors.red)),
                ),
              ),
            ),
          ],
        ),
      ),

      body: _pages[_selectedIndex],
    );
  }
}
