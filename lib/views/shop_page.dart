import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/controllers/cart_controller.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  // ── Coffee menu data ─────────────────────────────
  static const List<Map<String, dynamic>> _coffeeList = [
    {
      'id': 1,
      'name': 'Espresso',
      'description': 'Rich & bold single shot',
      'price': 150,
      'imagePath': 'assets/blask.jpg',
    },
    {
      'id': 2,
      'name': 'Cappuccino',
      'description': 'Espresso with steamed milk foam',
      'price': 250,
      'imagePath': 'assets/coffe.jpg',
    },
    {
      'id': 3,
      'name': 'Latte',
      'description': 'Smooth espresso & steamed milk',
      'price': 280,
      'imagePath': 'assets/ska.jpg',
    },
    {
      'id': 4,
      'name': 'Americano',
      'description': 'Espresso diluted with hot water',
      'price': 200,
      'imagePath': 'assets/coffee.jpg',
    },
    {
      'id': 5,
      'name': 'Cold Brew',
      'description': '12-hour slow brewed, smooth finish',
      'price': 350,
      'imagePath': 'assets/cool.jpg',
    },
    {
      'id': 6,
      'name': 'Iced Latte',
      'description': 'Chilled latte over ice',
      'price': 320,
      'imagePath': 'assets/milkt.jpg',
    },
    {
      'id': 7,
      'name': 'Macchiato',
      'description': 'Espresso marked with foamed milk',
      'price': 270,
      'imagePath': 'assets/coffe.jpg',
    },
    {
      'id': 8,
      'name': 'Frappuccino',
      'description': 'Blended coffee with whipped cream',
      'price': 380,
      'imagePath': 'assets/icey.jpg',
    },
    {
      'id': 9,
      'name': 'Croissant',
      'description': 'Buttery, flaky baked pastry',
      'price': 180,
      'imagePath': 'assets/grug.jpg',
    },
    {
      'id': 10,
      'name': 'Muffin',
      'description': 'Blueberry or choco chip',
      'price': 150,
      'imagePath': 'assets/greent.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.isRegistered<CartController>()
        ? Get.find<CartController>()
        : Get.put(CartController());

    return SingleChildScrollView(
      child: Column(
        children: [
          // ── Search bar ───────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.yellow[200],
              ),
            ),
          ),

          // ── Tagline ──────────────────────────────
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Text(
              'I like my coffee how I like myself — strong, sweet, and too hot for you',
              style: TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 16),

          // ── Coffee list ──────────────────────────
          ListView.builder(
            itemCount: _coffeeList.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final coffee = _coffeeList[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 8,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.brown.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Image
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                        ),
                        child: Image.asset(
                          coffee['imagePath'],
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 100,
                            height: 100,
                            color: Colors.amber[50],
                            child: Icon(
                              Icons.coffee_rounded,
                              color: Colors.amber[300],
                              size: 40,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Name, description & price
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              coffee['name'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              coffee['description'],
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'KSh ${coffee['price']}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Add to cart button
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: GestureDetector(
                          onTap: () => cartController.addToCart(coffee),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: Colors.yellow[700],
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
