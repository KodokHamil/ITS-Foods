import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io' as io;
import 'cart_model.dart';

class DBHelper {
  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db!;
    }

    _db = await initDatabase();
    return _db;
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'cart.db');
    print("Database path: $path"); 
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE cart (id INTEGER PRIMARY KEY AUTOINCREMENT, foodID TEXT UNIQUE, foodName TEXT, initialPrice INTEGER, foodPrice INTEGER, quantity INTEGER, unitTag TEXT, image TEXT)'
    );
  }

  Future<Cart> insert(Cart cart) async {
    var dbClient = await db;
    await dbClient!.insert('cart', cart.toMap());
    return cart;
  }

  Future<int> insertOrUpdateCart(Cart cart) async {
    var dbClient = await db;

    // Check if the foodID already exists
    var existingCart = await dbClient!.query(
      'cart',
      where: 'foodID = ?',
      whereArgs: [cart.foodID],
    );
    if (existingCart.isEmpty) {
      // Insert new item
      return await dbClient.insert('cart', cart.toMap());
    } else {
      // Update existing item
      return await dbClient.update(
        'cart',
        cart.toMap(),
        where: 'foodID = ?',
        whereArgs: [cart.foodID],
      );
    }
  }

  Future<List<Cart>> getCartList() async {
    var dbClient = await db;
    final List<Map<String, Object?>> queryResult = await dbClient!.query('cart');
    return queryResult.map((e) => Cart.fromMap(e)).toList();
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient!.delete('cart', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateQuantity(int id, int quantity) async {
    var dbClient = await db;
    return await dbClient!.update(
      'cart',
      {'quantity': quantity},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
