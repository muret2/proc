import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/services/database_service.dart';
import 'package:flutter_application_1/controllers/profile_controller.dart';
import 'package:flutter_application_1/views/orders_page.dart';

class OrdersController extends GetxController {
  var orders = <Order>[].obs;
  var isLoading = false.obs;
  var selectedFilter = 'All'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  List<Order> get filteredOrders {
    switch (selectedFilter.value) {
      case 'Active':
        return orders
            .where(
              (o) =>
                  o.status == OrderStatus.processing ||
                  o.status == OrderStatus.preparing,
            )
            .toList();
      case 'Done':
        return orders.where((o) => o.status == OrderStatus.delivered).toList();
      case 'Cancelled':
        return orders.where((o) => o.status == OrderStatus.cancelled).toList();
      default:
        return orders;
    }
  }

  void setFilter(String filter) => selectedFilter.value = filter;

  Future<void> fetchOrders() async {
    final userId = Get.find<ProfileController>().userId.value;
    if (userId.isEmpty) return;

    isLoading.value = true;
    final response = await DatabaseService.getOrders(int.parse(userId));
    isLoading.value = false;

    if (response["success"] == true) {
      final List data = response["data"];
      orders.value = data
          .map(
            (o) => Order(
              id: o["id"],
              items: List<Map<String, dynamic>>.from(o["items"]),
              total: (o["total"] as num).toInt(),
              date: DateTime.parse(o["date"]),
              status: _parseStatus(o["status"]),
            ),
          )
          .toList();
    } else {
      Get.snackbar(
        "Error",
        "Could not load your orders",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
    }
  }

  Future<void> reorder(Order order) async {
    final userId = Get.find<ProfileController>().userId.value;
    if (userId.isEmpty) return;

    isLoading.value = true;
    final response = await DatabaseService.placeOrder(
      userId: int.parse(userId),
      items: order.items
          .map(
            (item) => {
              "name": item["name"],
              "qty": item["qty"],
              "price": item["price"],
            },
          )
          .toList(),
      total: order.total.toDouble(),
    );
    isLoading.value = false;

    if (response["success"] == true) {
      Get.snackbar(
        "Order Placed! ☕",
        "Your reorder is being processed",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[100],
        colorText: Colors.green[800],
      );
      fetchOrders();
    } else {
      Get.snackbar(
        "Reorder Failed",
        response["message"] ?? "Could not place order",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
    }
  }

  Future<void> cancelOrder(String orderId) async {
    final numericId = int.tryParse(orderId.replaceAll(RegExp(r'[^0-9]'), ''));
    if (numericId == null) return;

    isLoading.value = true;
    final response = await DatabaseService.updateOrderStatus(
      orderId: numericId,
      status: 'cancelled',
    );
    isLoading.value = false;

    if (response["success"] == true) {
      final index = orders.indexWhere((o) => o.id == orderId);
      if (index >= 0) {
        final old = orders[index];
        orders[index] = Order(
          id: old.id,
          items: old.items,
          total: old.total,
          date: old.date,
          status: OrderStatus.cancelled,
        );
        orders.refresh();
      }
      Get.snackbar(
        "Order Cancelled",
        "Your order has been cancelled",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange[100],
        colorText: Colors.orange[800],
      );
    } else {
      Get.snackbar(
        "Failed",
        response["message"] ?? "Could not cancel order",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
    }
  }

  Future<void> submitCustomRequest({
    required String description,
    required String preferredTime,
  }) async {
    final userId = Get.find<ProfileController>().userId.value;
    if (userId.isEmpty) return;

    if (description.trim().isEmpty) {
      Get.snackbar(
        "Missing Info",
        "Please describe your custom order",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.amber[100],
        colorText: Colors.brown[800],
      );
      return;
    }

    isLoading.value = true;
    final response = await DatabaseService.placeOrder(
      userId: int.parse(userId),
      items: [
        {"name": "Custom: ${description.trim()}", "qty": 1, "price": 0},
      ],
      total: 0,
      note: preferredTime.trim().isNotEmpty ? preferredTime.trim() : null,
    );
    isLoading.value = false;

    if (response["success"] == true) {
      Get.snackbar(
        "Request Sent! ✓",
        "We'll confirm your custom order shortly",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[100],
        colorText: Colors.green[800],
        duration: const Duration(seconds: 3),
      );
      fetchOrders();
    } else {
      Get.snackbar(
        "Request Failed",
        response["message"] ?? "Could not send request. Try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
    }
  }

  OrderStatus _parseStatus(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return OrderStatus.delivered;
      case 'preparing':
        return OrderStatus.preparing;
      case 'cancelled':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.processing;
    }
  }
}
