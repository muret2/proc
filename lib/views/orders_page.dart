import 'package:flutter/material.dart';

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

final List<Order> sampleOrders = [
  Order(
    id: '#ORD-001',
    items: [
      {'name': 'Espresso', 'qty': 2, 'price': 235},
      {'name': 'Latte', 'qty': 1, 'price': 335},
    ],
    total: 805,
    date: DateTime.now().subtract(const Duration(days: 1)),
    status: OrderStatus.delivered,
  ),
  Order(
    id: '#ORD-002',
    items: [
      {'name': 'Cappuccino', 'qty': 1, 'price': 255},
      {'name': 'Frappuccino', 'qty': 2, 'price': 235},
    ],
    total: 725,
    date: DateTime.now().subtract(const Duration(hours: 3)),
    status: OrderStatus.preparing,
  ),
  Order(
    id: '#ORD-003',
    items: [
      {'name': 'Latte', 'qty': 3, 'price': 335},
    ],
    total: 1005,
    date: DateTime.now().subtract(const Duration(minutes: 30)),
    status: OrderStatus.processing,
  ),
];

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
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text(
              'My Orders',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            const SizedBox(height: 6),
            Text(
              '${sampleOrders.length} orders placed',
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
            const SizedBox(height: 20),

            // Summary chips
            Row(
              children: [
                _SummaryChip(
                  label: 'All',
                  count: sampleOrders.length,
                  color: Colors.yellow[700]!,
                  selected: true,
                ),
                const SizedBox(width: 8),
                _SummaryChip(
                  label: 'Active',
                  count: sampleOrders
                      .where(
                        (o) =>
                            o.status == OrderStatus.preparing ||
                            o.status == OrderStatus.processing,
                      )
                      .length,
                  color: Colors.orange,
                ),
                const SizedBox(width: 8),
                _SummaryChip(
                  label: 'Done',
                  count: sampleOrders
                      .where((o) => o.status == OrderStatus.delivered)
                      .length,
                  color: Colors.green,
                ),
              ],
            ),

            const SizedBox(height: 20),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: sampleOrders.length,
              separatorBuilder: (_, _) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final order = sampleOrders[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.brown,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              order.id,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
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
                                    color: _statusColor(order.status),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    _statusLabel(order.status),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: _statusColor(order.status),
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
                        ...order.items.map(
                          (item) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
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
                                    Text(
                                      item['name'],
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ],
                                ),
                                Text(
                                  'KSh ${item['price'] * item['qty']}',
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
                            Text(
                              'Total: KSh ${order.total}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.brown,
                              ),
                            ),
                          ],
                        ),
                        if (order.status == OrderStatus.delivered) ...[
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () {},
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
  }
}

class _SummaryChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  final bool selected;

  const _SummaryChip({
    required this.label,
    required this.count,
    required this.color,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: selected ? color : Colors.grey[100],
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
              style: TextStyle(
                fontSize: 11,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
