import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/controllers/cart_controller.dart';
import 'package:flutter_application_1/services/database_service.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.isRegistered<CartController>()
        ? Get.find<CartController>()
        : Get.put(CartController());

    final RxList<Map<String, dynamic>> products = <Map<String, dynamic>>[].obs;
    final RxBool isLoading = true.obs;
    final RxString error = ''.obs;

    Future.microtask(() async {
      final response = await DatabaseService.getProducts();
      isLoading.value = false;
      if (response['success'] == true) {
        products.value = List<Map<String, dynamic>>.from(response['data']);
      } else {
        error.value = response['message'] ?? 'Failed to load products';
      }
    });

    return SingleChildScrollView(
      child: Column(
        children: [
          // Search bar
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

          // Tagline
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Text(
              'I like my coffee how I like myself — strong, sweet, and too hot for you',
              style: TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 16),

          // Product list
          Obx(() {
            // Loading
            if (isLoading.value) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 60),
                child: Center(
                  child: CircularProgressIndicator(color: Colors.amber),
                ),
              );
            }

            // Error
            if (error.value.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 60),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.wifi_off_rounded,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        error.value,
                        style: TextStyle(color: Colors.grey[600]),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () async {
                          isLoading.value = true;
                          error.value = '';
                          final response = await DatabaseService.getProducts();
                          isLoading.value = false;
                          if (response['success'] == true) {
                            products.value = List<Map<String, dynamic>>.from(
                              response['data'],
                            );
                          } else {
                            error.value =
                                response['message'] ??
                                'Failed to load products';
                          }
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber[700],
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            // Empty
            if (products.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 60),
                child: Center(
                  child: Text(
                    'No products available',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ),
              );
            }

            // Product cards
            return ListView.builder(
              itemCount: products.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final coffee = products[index];
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
                          // ignore: deprecated_member_use
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
                            coffee['image_url'] ?? '',
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, err, stack) => Container(
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
                                coffee['name'] ?? '',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                coffee['description'] ?? '',
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
                            onTap: () => cartController.addToCart({
                              'id': coffee['id'],
                              'name': coffee['name'],
                              'description': coffee['description'],
                              'price':
                                  double.tryParse(coffee['price'].toString()) ??
                                  0.0,
                              'image_url': coffee['image_url'],
                              'imagePath': coffee['image_url'],
                            }),
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
            );
          }),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
