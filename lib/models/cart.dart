import 'package:flutter/material.dart';
import 'coffee.dart';

class Cart extends ChangeNotifier {
  // List of coffee for sale
  List<Coffee> coffeeShop = [
    Coffee(
      name: 'Espresso',
      price: '235',
      imagePath: 'assets/coffee.jpg',
      description: 'our modern coffee taste',
    ),
    Coffee(
      name: 'Cappuccino',
      price: '255',
      imagePath: 'assets/greent.jpg',
      description: 'our master mind flavour',
    ),
    Coffee(
      name: 'Latte',
      price: '335',
      imagePath: 'assets/icey.jpg',
      description: 'taste to leave you confident',
    ),
    Coffee(
      name: 'Frappuccino',
      price: '235',
      imagePath: 'assets/milkt.jpg',
      description: 'enjoying your moment',
    ),
  ];

  // List of items in user cart
  List<Coffee> userCart = [];

  // Get list of coffee for sale
  List<Coffee> getCoffeeList() {
    return coffeeShop;
  }

  // Get cart items — renamed from getUserList()
  List<Coffee> getUserCart() {
    return userCart;
  }

  // Get total price of all cart items
  int getTotalPrice() {
    int total = 0;
    for (var coffee in userCart) {
      total += int.parse(coffee.price);
    }
    return total;
  }

  // Add item to cart
  void addItemsToCart(Coffee coffee) {
    userCart.add(coffee);
    notifyListeners();
  }

  // Remove item from cart
  void removeItemFromCart(Coffee coffee) {
    userCart.remove(coffee);
    notifyListeners();
  }
}
