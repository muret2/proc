import 'package:flutter_application_1/views/home_page.dart';
import 'package:flutter_application_1/views/login_page.dart';
import 'package:flutter_application_1/views/signup_page.dart';
import 'package:get/get_navigation/get_navigation.dart';

var routes = [
  GetPage(name: "/", page: () => LoginPage()),
  GetPage(name: "/signup", page: () => SignUpPage()),
  GetPage(name: "/homepage", page: () => HomePage()),
];
