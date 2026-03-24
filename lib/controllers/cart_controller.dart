import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/services/database_service.dart';
import 'package:flutter_application_1/controllers/profile_controller.dart';
import 'package:flutter_application_1/controllers/orders_controller.dart';

class CartController extends GetxController {
  var cartItems = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  double get totalPrice => cartItems.fold(
    0.0,
    (sum, item) => sum + ((item["price"] as num) * (item["quantity"] as num)),
  );

  String get formattedTotal => 'KSh ${totalPrice.toStringAsFixed(0)}';
  int get itemCount => cartItems.length;

  void addToCart(Map<String, dynamic> product) {
    final index = cartItems.indexWhere((i) => i["id"] == product["id"]);
    if (index >= 0) {
      cartItems[index] = {
        ...cartItems[index],
        "quantity": cartItems[index]["quantity"] + 1,
      };
      cartItems.refresh();
    } else {
      cartItems.add({...product, "quantity": 1});
    }
    Get.snackbar(
      "Added to Cart ☕",
      "${product["name"]} added successfully",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.brown[100],
      colorText: Colors.brown[800],
      duration: const Duration(seconds: 1),
    );
  }

  void removeFromCart(dynamic item) {
    cartItems.removeWhere((i) => i["id"] == item["id"] || i == item);
  }

  void increaseQuantity(dynamic item) {
    final index = cartItems.indexWhere((i) => i["id"] == item["id"]);
    if (index >= 0) {
      cartItems[index] = {
        ...cartItems[index],
        "quantity": cartItems[index]["quantity"] + 1,
      };
      cartItems.refresh();
    }
  }

  void decreaseQuantity(dynamic item) {
    final index = cartItems.indexWhere((i) => i["id"] == item["id"]);
    if (index >= 0) {
      if (cartItems[index]["quantity"] > 1) {
        cartItems[index] = {
          ...cartItems[index],
          "quantity": cartItems[index]["quantity"] - 1,
        };
        cartItems.refresh();
      } else {
        removeFromCart(item);
      }
    }
  }

  void clearCart() => cartItems.clear();

  Future<bool> checkout() async {
    if (cartItems.isEmpty) {
      Get.snackbar(
        "Empty Cart",
        "Add some coffee before placing an order!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.amber[100],
        colorText: Colors.brown[800],
      );
      return false;
    }

    final userId = Get.find<ProfileController>().userId.value;
    if (userId.isEmpty) {
      Get.snackbar(
        "Error",
        "Please login to place an order",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
      return false;
    }

    isLoading.value = true;
    final response = await DatabaseService.placeOrder(
      userId: int.parse(userId),
      items: cartItems
          .map(
            (item) => {
              "name": item["name"],
              "qty": item["quantity"],
              "price": item["price"],
            },
          )
          .toList(),
      total: totalPrice,
    );
    isLoading.value = false;

    if (response["success"] == true) {
      clearCart();
      // Refresh orders list and profile stats
      Get.find<OrdersController>().fetchOrders();
      Get.snackbar(
        "Order Placed! ☕",
        "Your Great Coffee is being prepared",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[100],
        colorText: Colors.green[800],
      );
      return true;
    } else {
      Get.snackbar(
        "Checkout Failed",
        response["message"] ?? "Could not place order. Try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
      return false;
    }
  }
}
