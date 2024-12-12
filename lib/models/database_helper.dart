import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static final DatabaseHelper getInstance = DatabaseHelper._();

  static const String TABLE_CUSTOMER = 'customer';
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

  Future<Database> openDB() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String dbPath = join(appDir.path, "customer.db");

    return await openDatabase(dbPath, version: 1, onCreate: (db, version) {
      db.execute("""
        CREATE TABLE $TABLE_CUSTOMER(
        $COLUMN_CUSTOMER_NAME TEXT,
        $COLUMN_CUSTOMER_LOCATION TEXT,
        $COLUMN_CUSTOMER_AMOUNT REAL,
        $COLUMN_CUSTOMER_CRATE INTEGER,
        $COLUMN_CUSTOMER_PAGE INTEGER)
        """);
    });
  }
}
