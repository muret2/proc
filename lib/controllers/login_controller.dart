import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/services/database_service.dart';
import 'package:flutter_application_1/controllers/profile_controller.dart';

class LoginController extends GetxController {
  var isPassVisible = false.obs;
  var isLoading = false.obs;

  void togglePassword() => isPassVisible.value = !isPassVisible.value;

  Future<bool> login(String username, String password) async {
    if (username.trim().isEmpty || password.trim().isEmpty) {
      Get.snackbar(
        "Missing Fields",
        "Please enter your username and password",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.amber[100],
        colorText: Colors.brown[800],
      );
      return false;
    }
    if (password.length < 6) {
      Get.snackbar(
        "Weak Password",
        "Password must be at least 6 characters",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.amber[100],
        colorText: Colors.brown[800],
      );
      return false;
    }

    isLoading.value = true;
    final response = await DatabaseService.login(
      username: username.trim(),
      password: password.trim(),
    );
    isLoading.value = false;

    if (response["success"] == true) {
      Get.find<ProfileController>().setUser(response["user"]);
      return true;
    } else {
      Get.snackbar(
        "Login Failed",
        response["message"],
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
      return false;
    }
  }
}
