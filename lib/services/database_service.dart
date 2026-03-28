import 'dart:convert';
import 'package:http/http.dart' as http;

class DatabaseService {
  // Change this based on where you run the app
  // Chrome / browser:       http://localhost/coffee_api
  // Android emulator:       http://10.0.2.2/coffee_api
  // Real phone (same WiFi): http://YOUR_PC_IP/coffee_api
  //static const String _base = 'http://localhost/coffee_api';
   static const String _base = 'http://192.168.5.111/coffee_api';

  // SIGNUP
  static Future<Map<String, dynamic>> signup({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$_base/users.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'action': 'signup',
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
        }),
      );
      return jsonDecode(res.body);
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  //  LOGIN
  static Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$_base/users.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'action': 'login',
          'username': username,
          'password': password,
        }),
      );
      return jsonDecode(res.body);
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // UPDATE PROFILE
  static Future<Map<String, dynamic>> updateProfile({
    required int userId,
    required String name,
    required String phone,
    String address = '',
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$_base/users.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'action': 'update_profile',
          'user_id': userId,
          'name': name,
          'phone': phone,
          'address': address,
        }),
      );
      return jsonDecode(res.body);
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // UPDATE EMAIL
  static Future<Map<String, dynamic>> updateEmail({
    required int userId,
    required String newEmail,
    required String currentPassword,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$_base/users.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'action': 'update_email',
          'user_id': userId,
          'new_email': newEmail,
          'current_password': currentPassword,
        }),
      );
      return jsonDecode(res.body);
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // CHANGE PASSWORD
  static Future<Map<String, dynamic>> changePassword({
    required int userId,
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$_base/users.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'action': 'change_password',
          'user_id': userId,
          'current_password': currentPassword,
          'new_password': newPassword,
        }),
      );
      return jsonDecode(res.body);
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // GET PRODUCTS
  static Future<Map<String, dynamic>> getProducts({
    String category = '',
  }) async {
    try {
      final url = category.isEmpty
          ? '$_base/products.php'
          : '$_base/products.php?category=$category';
      final res = await http.get(Uri.parse(url));
      return jsonDecode(res.body);
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // PLACE ORDER
  static Future<Map<String, dynamic>> placeOrder({
    required int userId,
    required List<Map<String, dynamic>> items,
    required double total,
    String deliveryAddress = '',
    String? note,
  }) async {
    try {
      final orderItems = items
          .map(
            (item) => {
              'product_id': item['id'],
              'quantity': item['qty'] ?? item['quantity'] ?? 1,
              'unit_price': item['price'],
            },
          )
          .toList();

      final res = await http.post(
        Uri.parse('$_base/orders.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'action': 'place',
          'user_id': userId,
          'total_price': total,
          'delivery_address': deliveryAddress,
          'notes': note ?? '',
          'items': orderItems,
        }),
      );
      return jsonDecode(res.body);
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // GET ORDERS
  static Future<Map<String, dynamic>> getOrders(int userId) async {
    try {
      final res = await http.post(
        Uri.parse('$_base/orders.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'action': 'get', 'user_id': userId}),
      );

      final decoded = jsonDecode(res.body);
      if (decoded['success'] != true) return decoded;

      final List data = decoded['data'];
      final orders = data.map((o) {
        final List rawItems = o['items'] ?? [];
        final items = rawItems
            .map(
              (i) => {
                'name': i['product_name'] ?? '',
                'qty': i['quantity'] ?? 1,
                'price': double.tryParse(i['unit_price'].toString()) ?? 0.0,
              },
            )
            .toList();

        return {
          'id': '#ORD-${o['id'].toString().padLeft(3, '0')}',
          'items': items,
          'total': double.tryParse(o['total_price'].toString()) ?? 0.0,
          'status': o['status'] ?? 'pending',
          'note': o['notes'] ?? '',
          'date': o['created_at'] ?? DateTime.now().toIso8601String(),
        };
      }).toList();

      return {'success': true, 'data': orders};
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // UPDATE ORDER STATUS
  static Future<Map<String, dynamic>> updateOrderStatus({
    required int orderId,
    required String status,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$_base/orders.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'action': 'update_status',
          'order_id': orderId,
          'status': status,
        }),
      );
      return jsonDecode(res.body);
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  //  CANCEL ORDER
  static Future<Map<String, dynamic>> cancelOrder({
    required int orderId,
    required int userId,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$_base/orders.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'action': 'cancel',
          'order_id': orderId,
          'user_id': userId,
        }),
      );
      return jsonDecode(res.body);
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }
}
