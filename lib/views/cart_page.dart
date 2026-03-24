import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/cart_controller.dart';
import 'package:get/get.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Use Get.put so it's always registered even if binding missed it
    final CartController cart = Get.isRegistered<CartController>()
        ? Get.find<CartController>()
        : Get.put(CartController());

    return Obx(() {
      final items = cart.cartItems;
      final loading = cart.isLoading.value;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            // ── Header ────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'My Cart',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                if (items.isNotEmpty)
                  TextButton.icon(
                    onPressed: () => _confirmClear(context, cart),
                    icon: const Icon(
                      Icons.delete_outline,
                      size: 16,
                      color: Colors.red,
                    ),
                    label: const Text(
                      'Clear',
                      style: TextStyle(color: Colors.red, fontSize: 13),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),

            // ── Empty state ───────────────────────────
            if (items.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.coffee_outlined,
                        size: 64,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Your cart is empty',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Head to Home and add some coffee!',
                        style: TextStyle(fontSize: 13, color: Colors.grey[400]),
                      ),
                    ],
                  ),
                ),
              )
            else ...[
              // ── Cart item list ────────────────────────
              Expanded(
                child: ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final coffee = items[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.brown.withOpacity(0.08),
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
                              coffee['imagePath'] ?? '',
                              width: 88,
                              height: 88,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 88,
                                height: 88,
                                color: Colors.amber[50],
                                child: Icon(
                                  Icons.coffee_rounded,
                                  color: Colors.amber[300],
                                  size: 36,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Name & price
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  coffee['name'] ?? '',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  'KSh ${coffee['price']} each',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Subtotal: KSh ${(coffee['price'] as num) * (coffee['quantity'] as num)}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.brown[600],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Qty controls
                          Column(
                            children: [
                              _QtyButton(
                                icon: Icons.add,
                                color: Colors.amber[700]!,
                                onTap: () => cart.increaseQuantity(coffee),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                ),
                                child: Text(
                                  '${coffee['quantity']}',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              _QtyButton(
                                icon: Icons.remove,
                                color: Colors.red,
                                onTap: () => cart.decreaseQuantity(coffee),
                              ),
                            ],
                          ),
                          const SizedBox(width: 14),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 12),

              // ── Summary + Place Order ─────────────────
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.brown.withOpacity(0.1),
                      blurRadius: 12,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Item count + total
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${items.length} item(s)',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          'Total: ${cart.formattedTotal}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Place Order button — isLoading read INSIDE Obx ✓
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: loading
                            ? null
                            : () async {
                                await cart.checkout();
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber[700],
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.grey[300],
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 2,
                        ),
                        child: loading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Place Order',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ],
        ),
      );
    });
  }

  void _confirmClear(BuildContext context, CartController cart) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Clear Cart'),
        content: const Text('Remove all items from your cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              cart.clearCart();
              Navigator.pop(ctx);
            },
            child: const Text('Clear All', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

// ── +/- button widget ─────────────────────────────
class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  const _QtyButton({
    required this.icon,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 15, color: color),
      ),
    );
  }
}
