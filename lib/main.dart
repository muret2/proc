import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/login_page.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'models/cart.dart';
import 'configs/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Cart(),
      child: GetMaterialApp(
        initialRoute: '/',
        getPages: routes,
        debugShowCheckedModeBanner: false,
        home: const LoginPage(),
      ),
    );
  }
}
