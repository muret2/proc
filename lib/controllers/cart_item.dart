import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/cart_controller.dart';
import 'package:get/get.dart';

class CartItem extends StatelessWidget {
  final Map<String, dynamic> coffee;

  const CartItem({super.key, required this.coffee});

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Image.asset(
            coffee['imagePath'] ?? '',
            width: 48,
            height: 48,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 48,
              height: 48,
              color: Colors.amber[50],
              child: Icon(
                Icons.coffee_rounded,
                color: Colors.amber[300],
                size: 24,
              ),
            ),
          ),
        ),
        title: Text(
          coffee['name'] ?? '',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text('KSh ${coffee['price']}  ×  ${coffee['quantity']}'),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => cartController.removeFromCart(coffee),
        ),
      ),
    );
  }
}
