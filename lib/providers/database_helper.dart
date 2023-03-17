import 'dart:io';

import 'package:checkout_app/models/cart_product.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'checkout.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE cart_list(
          shopId TEXT,
          id INTEGER PRIMARY KEY,
          product_id TEXT,
          name TEXT,
          discount_price INTEGER,
          main_price INTEGER,
          currency TEXT,
          currency_position TEXT,
          thumbnail TEXT,
          unit TEXT,
          quantity INTEGER
      )
      ''');
  }

  Future<List<CartProduct>> getCart() async {
    Database db = await instance.database;
    List<CartProduct> cartList = [];
   // await db.transaction((txn) async {
      var cart = await db.query('cart_list', orderBy: 'id');

      cartList = cart.isNotEmpty
          ? cart.map((c) => CartProduct.fromMap(c)).toList()
          : [];
   // });

    return cartList;
  }

  Future<List<Map<String, dynamic>>> queryAllRows(table) async {
    Database db = await instance.database;
    var batch = db.batch();

    var result  = await db.query(table);
    // await db.transaction((txn) async {
    //   txn.batch();
    //  // await batch.commit(noResult: true);
    //   result = await txn.query(table);
    //   //batch.query(table);
    //   //result = await batch.commit(noResult: true);
    // });

    return result.toList();
  }

  Future addItem(CartProduct item) async {
    Database db = await instance.database;
    await db.transaction((txn) async {
      return await txn.insert('cart_list', item.toMap());
    });
  }

  Future<int> removeProduct(int? id) async {
    Database db = await instance.database;
    return await db.delete('cart_list', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateItem(int? id, int? quantity, dynamic price) async {
    Database db = await instance.database;
    return await db.rawUpdate(
        'UPDATE cart_list SET quantity = \'$quantity\', main_price = \'$price\' WHERE id = $id');
  }

  Future<int> removeCart() async {
    Database db = await instance.database;
    return await db.delete('cart_list');
  }

  Future<List<Map<String, dynamic>>> findItem(String? productId) async {
    Database db = await instance.database;
    return await db.rawQuery(
        "SELECT * FROM cart_list WHERE product_id LIKE '%$productId%'");
  }
}
