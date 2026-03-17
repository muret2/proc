import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/coffee.dart';
import 'package:provider/provider.dart';
import '../models/cart.dart';

class CartItem extends StatefulWidget {
  final Coffee coffee;

  const CartItem({super.key, required this.coffee});

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  void removeItemFromCart() {
    Provider.of<Cart>(context, listen: false).removeItemFromCart(widget.coffee);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Image.asset(widget.coffee.imagePath),
        title: Text(widget.coffee.name),
        subtitle: Text(widget.coffee.price),
        trailing: IconButton(
          icon: const Icon(Icons.delete), // fixed: Icon widget, not IconData
          onPressed: removeItemFromCart, // fixed: was removeItemFromCat (typo)
        ),
      ),
    );
  }
}
