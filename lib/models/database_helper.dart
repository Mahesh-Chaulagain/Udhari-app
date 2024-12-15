// dbhelper.dart
// ignore_for_file: constant_identifier_names

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
  static const String COLUMN_CUSTOMER_HISTORY = 'history';

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
        $COLUMN_CUSTOMER_AMOUNT INTEGER,
        $COLUMN_CUSTOMER_CRATE INTEGER,
        $COLUMN_CUSTOMER_PAGE INTEGER,
        $COLUMN_CUSTOMER_HISTORY TEXT)
        """);
    });
  }

  // Insert Data
  Future<bool> addData(
      {required String name,
      String? location,
      int? amount,
      int? crate,
      int? page,
      String? history}) async {
    var db = await getDB();
    int rowsEffected = await db.insert(TABLE_CUSTOMER, {
      COLUMN_CUSTOMER_NAME: name,
      COLUMN_CUSTOMER_LOCATION: location,
      COLUMN_CUSTOMER_AMOUNT: amount,
      COLUMN_CUSTOMER_CRATE: crate,
      COLUMN_CUSTOMER_PAGE: page,
      COLUMN_CUSTOMER_HISTORY: history,
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
      int? amount,
      int? crate,
      int? page,
      String? previousHistory,
      required int sno}) async {
    var db = await getDB();
    String updatedHistory = previousHistory ?? '';
    // updatedHistory +=
    //     ' Updated on ${DateTime.now()}'; // Appending the new history

    int rowEffected = await db.update(
        TABLE_CUSTOMER,
        {
          COLUMN_CUSTOMER_NAME: name,
          COLUMN_CUSTOMER_LOCATION: location,
          COLUMN_CUSTOMER_AMOUNT: amount,
          COLUMN_CUSTOMER_CRATE: crate,
          COLUMN_CUSTOMER_PAGE: page,
          COLUMN_CUSTOMER_HISTORY:
              updatedHistory, // Update the history with the appended value
        },
        where: '$COLUMN_CUSTOMER_SNO = ?',
        whereArgs: [sno]);

    return rowEffected > 0;
  }

  // Method for searching by name
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

// delete the whole database
Future<void> deleteOldDatabase() async {
  try {
    // Get the application documents directory path
    Directory appDir = await getApplicationDocumentsDirectory();

    // Set the database path using the same name as your database
    String dbPath = join(appDir.path, "customer.db");

    // Delete the database file
    await deleteDatabase(dbPath);

    print("Database deleted successfully.");
  } catch (e) {
    print("Error deleting database: $e");
  }
}
