import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/orders_controller.dart';
import 'package:get/get.dart';

enum OrderStatus { processing, preparing, delivered, cancelled }

class Order {
  final String id;
  final List<Map<String, dynamic>> items;
  final int total;
  final DateTime date;
  final OrderStatus status;

  Order({
    required this.id,
    required this.items,
    required this.total,
    required this.date,
    required this.status,
  });
}

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  Color _statusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.preparing:
        return Colors.orange;
      case OrderStatus.processing:
        return Colors.blue;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }

  IconData _statusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.delivered:
        return Icons.check_circle_outline;
      case OrderStatus.preparing:
        return Icons.coffee_outlined;
      case OrderStatus.processing:
        return Icons.hourglass_top_outlined;
      case OrderStatus.cancelled:
        return Icons.cancel_outlined;
    }
  }

  String _statusLabel(OrderStatus status) {
    switch (status) {
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.preparing:
        return 'Preparing';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  String _formatDate(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${date.day}/${date.month}/${date.year}';
  }

  // ── CANCEL CONFIRMATION DIALOG ───────────────────
  void _showCancelDialog(
    BuildContext context,
    Order order,
    OrdersController controller,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text(
          'Cancel Order',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Cancel ${order.id}? This action cannot be undone.',
          style: TextStyle(color: Colors.grey[700], fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Keep Order',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              controller.cancelOrder(order.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[400],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }

  // ── CUSTOM REQUEST BOTTOM SHEET ──────────────────
  void _showCustomRequestSheet(
    BuildContext context,
    OrdersController controller,
  ) {
    final descController = TextEditingController();
    final timeController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.amber[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.coffee_maker_outlined,
                    color: Colors.amber[700],
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Custom Order Request',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      'Tell us exactly what you want',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Description field
            TextField(
              controller: descController,
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: 'Describe your order',
                hintText:
                    'e.g. Double espresso with oat milk, extra hot, light sugar...',
                hintStyle: TextStyle(fontSize: 12, color: Colors.grey[400]),
                alignLabelWithHint: true,
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(bottom: 40),
                  child: Icon(Icons.edit_note_outlined),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.yellow[50],
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.amber[700]!, width: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Preferred time field
            TextField(
              controller: timeController,
              decoration: InputDecoration(
                labelText: 'Preferred time (optional)',
                hintText: 'e.g. ASAP, 3:00 PM, After 5pm...',
                hintStyle: TextStyle(fontSize: 12, color: Colors.grey[400]),
                prefixIcon: const Icon(Icons.schedule_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.yellow[50],
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.amber[700]!, width: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 22),

            // Submit button
            Obx(
              () => SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: controller.isLoading.value
                      ? null
                      : () async {
                          await controller.submitCustomRequest(
                            description: descController.text,
                            preferredTime: timeController.text,
                          );
                          if (ctx.mounted) Navigator.pop(ctx);
                        },
                  icon: controller.isLoading.value
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.send_outlined, size: 18),
                  label: Text(
                    controller.isLoading.value ? 'Sending...' : 'Send Request',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber[700],
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey[300],
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final OrdersController ordersController = Get.find<OrdersController>();

    return Obx(() {
      if (ordersController.isLoading.value && ordersController.orders.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(color: Colors.amber),
        );
      }

      final orders = ordersController.filteredOrders;

      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              // ── Header row ──────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'My Orders',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${ordersController.orders.length} orders placed',
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                    ],
                  ),

                  // Custom Request button
                  GestureDetector(
                    onTap: () =>
                        _showCustomRequestSheet(context, ordersController),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber[700],
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.amber.withOpacity(0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add, color: Colors.white, size: 16),
                          SizedBox(width: 5),
                          Text(
                            'Custom Order',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ── Filter chips ───────────────────────
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _SummaryChip(
                      label: 'All',
                      count: ordersController.orders.length,
                      color: Colors.amber[700]!,
                      selected: ordersController.selectedFilter.value == 'All',
                      onTap: () => ordersController.setFilter('All'),
                    ),
                    const SizedBox(width: 8),
                    _SummaryChip(
                      label: 'Active',
                      count: ordersController.orders
                          .where(
                            (o) =>
                                o.status == OrderStatus.preparing ||
                                o.status == OrderStatus.processing,
                          )
                          .length,
                      color: Colors.orange,
                      selected:
                          ordersController.selectedFilter.value == 'Active',
                      onTap: () => ordersController.setFilter('Active'),
                    ),
                    const SizedBox(width: 8),
                    _SummaryChip(
                      label: 'Done',
                      count: ordersController.orders
                          .where((o) => o.status == OrderStatus.delivered)
                          .length,
                      color: Colors.green,
                      selected: ordersController.selectedFilter.value == 'Done',
                      onTap: () => ordersController.setFilter('Done'),
                    ),
                    const SizedBox(width: 8),
                    _SummaryChip(
                      label: 'Cancelled',
                      count: ordersController.orders
                          .where((o) => o.status == OrderStatus.cancelled)
                          .length,
                      color: Colors.red,
                      selected:
                          ordersController.selectedFilter.value == 'Cancelled',
                      onTap: () => ordersController.setFilter('Cancelled'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── Empty state ────────────────────────
              if (orders.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 60),
                    child: Column(
                      children: [
                        Icon(
                          Icons.coffee_outlined,
                          size: 64,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No orders here yet',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Order some Great Coffee to get started!',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[400],
                          ),
                        ),
                        const SizedBox(height: 24),
                        OutlinedButton.icon(
                          onPressed: () => _showCustomRequestSheet(
                            context,
                            ordersController,
                          ),
                          icon: const Icon(
                            Icons.coffee_maker_outlined,
                            size: 16,
                          ),
                          label: const Text('Make a Custom Request'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.amber[700],
                            side: BorderSide(color: Colors.amber[700]!),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              // ── Order cards ────────────────────────
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: orders.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    final isActive =
                        order.status == OrderStatus.processing ||
                        order.status == OrderStatus.preparing;
                    final isCustom =
                        order.items.isNotEmpty &&
                        (order.items.first['name'] as String).startsWith(
                          'Custom:',
                        );

                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: isCustom
                            ? Border.all(color: Colors.amber[300]!, width: 1.5)
                            : null,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.brown.withOpacity(0.12),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Order ID + Status badge
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    if (isCustom) ...[
                                      Icon(
                                        Icons.coffee_maker_outlined,
                                        size: 14,
                                        color: Colors.amber[600],
                                      ),
                                      const SizedBox(width: 4),
                                    ],
                                    Text(
                                      order.id,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    if (isCustom) ...[
                                      const SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.amber[50],
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: Text(
                                          'Custom',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.amber[700],
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _statusColor(order.status),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        _statusIcon(order.status),
                                        size: 13,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        _statusLabel(order.status),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),
                            const Divider(height: 1),
                            const SizedBox(height: 10),

                            // Order items
                            ...order.items.map(
                              (item) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 3,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 22,
                                          height: 22,
                                          decoration: BoxDecoration(
                                            color: Colors.yellow[100],
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${item['qty']}x',
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.brown[700],
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        SizedBox(
                                          width: 180,
                                          child: Text(
                                            item['name'],
                                            style: const TextStyle(
                                              fontSize: 13,
                                            ),
                                            softWrap: true,
                                          ),
                                        ),
                                      ],
                                    ),
                                    if ((item['price'] as num) > 0)
                                      Text(
                                        'KSh ${(item['price'] as num) * (item['qty'] as num)}',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 10),
                            const Divider(height: 1),
                            const SizedBox(height: 10),

                            // Date + Total
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      size: 13,
                                      color: Colors.grey[500],
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      _formatDate(order.date),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                  ],
                                ),
                                if (order.total > 0)
                                  Text(
                                    'Total: KSh ${order.total}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.brown,
                                    ),
                                  )
                                else
                                  Text(
                                    'Awaiting confirmation',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.amber[700],
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                              ],
                            ),

                            // Action buttons
                            if (order.status == OrderStatus.delivered) ...[
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton.icon(
                                  onPressed: () =>
                                      ordersController.reorder(order),
                                  icon: const Icon(Icons.refresh, size: 16),
                                  label: const Text('Reorder'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.brown,
                                    side: const BorderSide(color: Colors.brown),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                            ] else if (isActive) ...[
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton.icon(
                                  onPressed: () => _showCancelDialog(
                                    context,
                                    order,
                                    ordersController,
                                  ),
                                  icon: const Icon(
                                    Icons.cancel_outlined,
                                    size: 16,
                                    color: Colors.red,
                                  ),
                                  label: const Text('Cancel Order'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.red,
                                    side: const BorderSide(
                                      color: Colors.red,
                                      width: 1,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      );
    });
  }
}

// ── Summary filter chip ────────────────────────────
class _SummaryChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _SummaryChip({
    required this.label,
    required this.count,
    required this.color,
    required this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.1) : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? color : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: selected ? color : Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
