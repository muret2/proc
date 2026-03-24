import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/controllers/profile_controller.dart';
import 'package:flutter_application_1/controllers/login_controller.dart';
import 'package:flutter_application_1/controllers/signup_controller.dart';
import 'package:flutter_application_1/controllers/cart_controller.dart';
import 'package:flutter_application_1/controllers/orders_controller.dart';
import 'package:flutter_application_1/configs/routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Pure GetX — no Provider wrapper needed
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: BindingsBuilder(() {
        Get.put(ProfileController(), permanent: true);
        Get.put(LoginController(), permanent: true);
        Get.put(SignupController(), permanent: true);
        Get.put(CartController(), permanent: true);
        Get.put(OrdersController(), permanent: true);
      }),
      initialRoute: '/',
      getPages: routes,
    );
  }
}
