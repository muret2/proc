import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'greatcoffee.db');

    return await openDatabase(
      path,
      version: 2, // bumped for migration
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            email TEXT UNIQUE NOT NULL,
            phone TEXT,
            password TEXT NOT NULL,
            created_at TEXT DEFAULT CURRENT_TIMESTAMP
          )
        ''');

        await db.execute('''
          CREATE TABLE orders (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER NOT NULL,
            items TEXT NOT NULL,
            total REAL NOT NULL,
            status TEXT DEFAULT 'processing',
            note TEXT,
            created_at TEXT DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (user_id) REFERENCES users(id)
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Add note column to existing orders table
          await db.execute('ALTER TABLE orders ADD COLUMN note TEXT');
        }
      },
    );
  }

  // ── SIGNUP ──────────────────────────────────────
  static Future<Map<String, dynamic>> signup({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      final db = await database;

      final existing = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [email],
      );

      if (existing.isNotEmpty) {
        return {"success": false, "message": "Email already registered"};
      }

      await db.insert('users', {
        "name": name,
        "email": email,
        "phone": phone,
        "password": password,
        "created_at": DateTime.now().toIso8601String(),
      });

      return {"success": true, "message": "Account created successfully"};
    } catch (e) {
      return {"success": false, "message": "Signup failed: $e"};
    }
  }

  // ── LOGIN ───────────────────────────────────────
  static Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    try {
      final db = await database;

      final result = await db.query(
        'users',
        where: '(email = ? OR phone = ?) AND password = ?',
        whereArgs: [username, username, password],
      );

      if (result.isEmpty) {
        return {"success": false, "message": "Invalid username or password"};
      }

      final user = result.first;

      final orders = await db.query(
        'orders',
        where: 'user_id = ?',
        whereArgs: [user['id']],
      );

      final totalSpent = orders.fold<double>(
        0,
        (sum, o) => sum + (o['total'] as num).toDouble(),
      );

      final createdAt = DateTime.parse(user['created_at'] as String);
      final memberSince = '${_monthName(createdAt.month)} ${createdAt.year}';

      return {
        "success": true,
        "user": {
          "id": user['id'],
          "name": user['name'],
          "email": user['email'],
          "phone": user['phone'],
          "total_orders": orders.length,
          "total_spent": totalSpent.toInt(),
          "member_since": memberSince,
        },
      };
    } catch (e) {
      return {"success": false, "message": "Login failed: $e"};
    }
  }

  // ── UPDATE PROFILE (name & phone) ───────────────
  static Future<Map<String, dynamic>> updateProfile({
    required int userId,
    required String name,
    required String phone,
  }) async {
    try {
      final db = await database;
      await db.update(
        'users',
        {"name": name, "phone": phone},
        where: 'id = ?',
        whereArgs: [userId],
      );
      return {"success": true, "message": "Profile updated"};
    } catch (e) {
      return {"success": false, "message": "Update failed: $e"};
    }
  }

  // ── UPDATE EMAIL ────────────────────────────────
  static Future<Map<String, dynamic>> updateEmail({
    required int userId,
    required String newEmail,
    required String currentPassword,
  }) async {
    try {
      final db = await database;

      // Verify current password first
      final user = await db.query(
        'users',
        where: 'id = ? AND password = ?',
        whereArgs: [userId, currentPassword],
      );

      if (user.isEmpty) {
        return {
          "success": false,
          "message": "Incorrect password. Please try again.",
        };
      }

      // Check email not already taken
      final existing = await db.query(
        'users',
        where: 'email = ? AND id != ?',
        whereArgs: [newEmail, userId],
      );

      if (existing.isNotEmpty) {
        return {"success": false, "message": "This email is already in use"};
      }

      await db.update(
        'users',
        {"email": newEmail},
        where: 'id = ?',
        whereArgs: [userId],
      );

      return {"success": true, "message": "Email updated"};
    } catch (e) {
      return {"success": false, "message": "Email update failed: $e"};
    }
  }

  // ── CHANGE PASSWORD ─────────────────────────────
  static Future<Map<String, dynamic>> changePassword({
    required int userId,
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final db = await database;

      // Verify current password
      final user = await db.query(
        'users',
        where: 'id = ? AND password = ?',
        whereArgs: [userId, currentPassword],
      );

      if (user.isEmpty) {
        return {"success": false, "message": "Current password is incorrect"};
      }

      await db.update(
        'users',
        {"password": newPassword},
        where: 'id = ?',
        whereArgs: [userId],
      );

      return {"success": true, "message": "Password changed"};
    } catch (e) {
      return {"success": false, "message": "Password change failed: $e"};
    }
  }

  // ── PLACE ORDER ─────────────────────────────────
  static Future<Map<String, dynamic>> placeOrder({
    required int userId,
    required List<Map<String, dynamic>> items,
    required double total,
    String? note,
  }) async {
    try {
      final db = await database;
      await db.insert('orders', {
        "user_id": userId,
        "items": items
            .map(
              (i) => '${i["name"]}|${i["qty"] ?? i["quantity"]}|${i["price"]}',
            )
            .join(','),
        "total": total,
        "status": "processing",
        "note": note,
        "created_at": DateTime.now().toIso8601String(),
      });
      return {"success": true, "message": "Order placed"};
    } catch (e) {
      return {"success": false, "message": "Order failed: $e"};
    }
  }

  // ── UPDATE ORDER STATUS ─────────────────────────
  static Future<Map<String, dynamic>> updateOrderStatus({
    required int orderId,
    required String status,
  }) async {
    try {
      final db = await database;
      final count = await db.update(
        'orders',
        {"status": status},
        where: 'id = ?',
        whereArgs: [orderId],
      );

      if (count == 0) {
        return {"success": false, "message": "Order not found"};
      }

      return {"success": true, "message": "Order status updated"};
    } catch (e) {
      return {"success": false, "message": "Could not update order: $e"};
    }
  }

  // ── GET ORDERS ──────────────────────────────────
  static Future<Map<String, dynamic>> getOrders(int userId) async {
    try {
      final db = await database;
      final rows = await db.query(
        'orders',
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'created_at DESC',
      );

      final orders = rows.map((row) {
        final itemStrings = (row['items'] as String).split(',');
        final items = itemStrings.map((s) {
          final parts = s.split('|');
          return {
            'name': parts[0],
            'qty': int.tryParse(parts[1]) ?? 1,
            'price': double.tryParse(parts[2]) ?? 0.0,
          };
        }).toList();

        return {
          "id": '#ORD-${row['id'].toString().padLeft(3, '0')}',
          "items": items,
          "total": row['total'],
          "status": row['status'],
          "note": row['note'],
          "date": row['created_at'],
        };
      }).toList();

      return {"success": true, "data": orders};
    } catch (e) {
      return {"success": false, "message": "Could not load orders: $e"};
    }
  }

  // ── HELPER ──────────────────────────────────────
  static String _monthName(int month) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month];
  }
}
