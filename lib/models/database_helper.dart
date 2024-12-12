import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static final DatabaseHelper getInstance = DatabaseHelper._();

  static const String TABLE_CUSTOMER = 'customer';
  static const String COLUMN_CUSTOMER_SNO = "s_no";
  static const String COLUMN_CUSTOMER_NAME = 'name';
  static const String COLUMN_CUSTOMER_LOCATION = 'location';
  static const String COLUMN_CUSTOMER_AMOUNT = 'amount';
  static const String COLUMN_CUSTOMER_CRATE = 'crate';
  static const String COLUMN_CUSTOMER_PAGE = 'page';

  Database? myDB;

  Future<Database> getDB() async {
    myDB ??= await openDB();
    return myDB!;
  }

  // Open Database
  Future<Database> openDB() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String dbPath = join(appDir.path, "customer.db");

    return await openDatabase(dbPath, version: 1, onCreate: (db, version) {
      db.execute("""
        CREATE TABLE $TABLE_CUSTOMER(
        $COLUMN_CUSTOMER_SNO INTEGER PRIMARY KEY AUTOINCREMENT,
        $COLUMN_CUSTOMER_NAME TEXT,
        $COLUMN_CUSTOMER_LOCATION TEXT,
        $COLUMN_CUSTOMER_AMOUNT REAL,
        $COLUMN_CUSTOMER_CRATE INTEGER,
        $COLUMN_CUSTOMER_PAGE INTEGER)
        """);
    });
  }

  // Insert Data
  Future<bool> addData(
      {required String name,
      String? location,
      double? amount,
      int? crate,
      int? page}) async {
    var db = await getDB();
    int rowsEffected = await db.insert(TABLE_CUSTOMER, {
      COLUMN_CUSTOMER_NAME: name,
      COLUMN_CUSTOMER_LOCATION: location,
      COLUMN_CUSTOMER_AMOUNT: amount,
      COLUMN_CUSTOMER_CRATE: crate,
      COLUMN_CUSTOMER_PAGE: page,
    });
    return rowsEffected > 0;
  }

  // Read all Data
  Future<List<Map<String, dynamic>>> getAllData() async {
    var db = await getDB();
    List<Map<String, dynamic>> cData = await db.query(TABLE_CUSTOMER);
    return cData;
  }

  // Update Data
  Future<bool> updateData(
      {String? name,
      String? location,
      double? amount,
      int? crate,
      int? page,
      required int sno}) async {
    var db = await getDB();
    int rowEffected = await db.update(
        TABLE_CUSTOMER,
        {
          COLUMN_CUSTOMER_NAME: name,
          COLUMN_CUSTOMER_LOCATION: location,
          COLUMN_CUSTOMER_AMOUNT: amount,
          COLUMN_CUSTOMER_CRATE: crate,
          COLUMN_CUSTOMER_PAGE: page,
        },
        where: '$COLUMN_CUSTOMER_SNO = ?',
        whereArgs: [sno]);

    return rowEffected > 0;
  }

  // method for searching by name
  Future<List<Map<String, dynamic>>> searchByName(String name) async {
    final db = await getDB();
    return await db.query(
      TABLE_CUSTOMER,
      where: '$COLUMN_CUSTOMER_NAME LIKE ?',
      whereArgs: ['%$name%'],
    );
  }

  // Method for searching by location
  Future<List<Map<String, dynamic>>> searchByLocation(String location) async {
    final db = await getDB();
    return await db.query(
      TABLE_CUSTOMER,
      where: '$COLUMN_CUSTOMER_LOCATION LIKE ?',
      whereArgs: ['%$location%'],
    );
  }

  // Method for searching by both name and location
  Future<List<Map<String, dynamic>>> searchByNameAndLocation(
      String name, String location) async {
    final db = await getDB();
    return await db.query(
      TABLE_CUSTOMER,
      where:
          '$COLUMN_CUSTOMER_NAME LIKE ? AND $COLUMN_CUSTOMER_LOCATION LIKE ?',
      whereArgs: ['%$name%', '%$location%'],
    );
  }
}
