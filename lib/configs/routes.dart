import 'package:flutter_application_1/views/home_page.dart';
import 'package:flutter_application_1/views/login_page.dart';
import 'package:flutter_application_1/views/signup_page.dart';
import 'package:get/get.dart';

var routes = [
  GetPage(name: '/', page: () => const LoginPage()),
  GetPage(name: '/signup', page: () => const SignUpPage()),
  GetPage(name: '/homepage', page: () => const HomePage()),
];
