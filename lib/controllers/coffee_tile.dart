import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/coffee.dart';

class CoffeeTile extends StatelessWidget {
  final Coffee coffee;
  final void Function()? onTap;

  const CoffeeTile({super.key, required this.coffee, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 25),
      width: 280,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Coffee picture
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(coffee.imagePath),
          ),

          // Description
          Text(coffee.description, style: TextStyle(color: Colors.grey[500])),

          // Price and details
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    Text(
                      coffee.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 5),
                    // Price
                    Text(
                      coffee.price,
                      style: const TextStyle(color: Colors.blue),
                    ),
                  ],
                ),

                // Add to cart button
                GestureDetector(
                  onTap: onTap,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Colors.amberAccent,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        topLeft: Radius.circular(12),
                      ),
                    ),
                    child: const Icon(Icons.add, color: Colors.black12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
