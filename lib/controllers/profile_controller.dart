import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/services/database_service.dart';

class ProfileController extends GetxController {
  var name = ''.obs;
  var email = ''.obs;
  var phone = ''.obs;
  var totalOrders = 0.obs;
  var totalSpent = 0.obs;
  var memberSince = ''.obs;
  var userId = ''.obs;
  var isLoading = false.obs;

  // ── SET USER DATA ───────────────────────────────
  void setUser(Map<String, dynamic> userData) {
    userId.value = userData["id"]?.toString() ?? '';
    name.value = userData["name"] ?? '';
    email.value = userData["email"] ?? '';
    phone.value = userData["phone"] ?? '';
    totalOrders.value = userData["total_orders"] ?? 0;
    totalSpent.value = userData["total_spent"] ?? 0;
    memberSince.value = userData["member_since"] ?? '';
  }

  // ── UPDATE NAME & PHONE ─────────────────────────
  Future<void> updateProfile(String newName, String newPhone) async {
    if (newName.trim().isEmpty || newPhone.trim().isEmpty) {
      Get.snackbar(
        "Missing Fields",
        "Name and phone cannot be empty",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.amber[100],
        colorText: Colors.brown[800],
      );
      return;
    }
    if (userId.value.isEmpty) {
      Get.snackbar(
        "Error",
        "User not found. Please login again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
      return;
    }

    isLoading.value = true;
    final response = await DatabaseService.updateProfile(
      userId: int.parse(userId.value),
      name: newName.trim(),
      phone: newPhone.trim(),
    );
    isLoading.value = false;

    if (response["success"] == true) {
      name.value = newName.trim();
      phone.value = newPhone.trim();
      Get.snackbar(
        "Profile Updated ✓",
        "Your details have been saved",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[100],
        colorText: Colors.green[800],
      );
    } else {
      Get.snackbar(
        "Update Failed",
        response["message"] ?? "Could not update profile",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
    }
  }

  // ── UPDATE EMAIL ────────────────────────────────
  Future<void> updateEmail({
    required String newEmail,
    required String currentPassword,
  }) async {
    if (newEmail.trim().isEmpty || currentPassword.trim().isEmpty) {
      Get.snackbar(
        "Missing Fields",
        "Please fill in all fields",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.amber[100],
        colorText: Colors.brown[800],
      );
      return;
    }

    if (!GetUtils.isEmail(newEmail.trim())) {
      Get.snackbar(
        "Invalid Email",
        "Please enter a valid email address",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.amber[100],
        colorText: Colors.brown[800],
      );
      return;
    }

    if (userId.value.isEmpty) return;

    isLoading.value = true;
    final response = await DatabaseService.updateEmail(
      userId: int.parse(userId.value),
      newEmail: newEmail.trim(),
      currentPassword: currentPassword,
    );
    isLoading.value = false;

    if (response["success"] == true) {
      email.value = newEmail.trim();
      Get.snackbar(
        "Email Updated ✓",
        "Your email address has been changed",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[100],
        colorText: Colors.green[800],
      );
    } else {
      Get.snackbar(
        "Update Failed",
        response["message"] ?? "Could not update email",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
    }
  }

  // ── CHANGE PASSWORD ─────────────────────────────
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    if (currentPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmPassword.isEmpty) {
      Get.snackbar(
        "Missing Fields",
        "Please fill in all password fields",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.amber[100],
        colorText: Colors.brown[800],
      );
      return;
    }

    if (newPassword != confirmPassword) {
      Get.snackbar(
        "Passwords Don't Match",
        "New password and confirmation must match",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
      return;
    }

    if (newPassword.length < 6) {
      Get.snackbar(
        "Weak Password",
        "Password must be at least 6 characters",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.amber[100],
        colorText: Colors.brown[800],
      );
      return;
    }

    if (userId.value.isEmpty) return;

    isLoading.value = true;
    final response = await DatabaseService.changePassword(
      userId: int.parse(userId.value),
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
    isLoading.value = false;

    if (response["success"] == true) {
      Get.snackbar(
        "Password Changed ✓",
        "Your password has been updated",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[100],
        colorText: Colors.green[800],
      );
    } else {
      Get.snackbar(
        "Change Failed",
        response["message"] ?? "Could not change password",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
    }
  }

  // ── LOGOUT ──────────────────────────────────────
  void logout() {
    userId.value = '';
    name.value = '';
    email.value = '';
    phone.value = '';
    totalOrders.value = 0;
    totalSpent.value = 0;
    memberSince.value = '';
    Get.offAllNamed('/');
  }
}
