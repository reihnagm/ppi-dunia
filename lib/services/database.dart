import 'package:sqflite/sqlite_api.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DBHelper {  
  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return await sql.openDatabase(path.join(dbPath, 'users.db'), onCreate: (db, version) => createDb(db), version: 1);
  }

  static Future<void> createDb(Database db) async {
    await db.execute(
      "CREATE TABLE ecomm_wishlist (id TEXT, owner TEXT, name TEXT, description TEXT, open TEXT)"
    );
    await db.execute("CREATE TABLE accounts (id INT, status INT, createdAt TEXT)");
    await db.execute("CREATE TABLE contacts (id INT, phone TEXT, name TEXT, status TEXT)");
    await db.execute("CREATE TABLE banks (id INT, img TEXT, name TEXT, channel TEXT)");
  }

  static Future<void> deleteAccounts() async {
    Database db = await DBHelper.database();
    await db.rawQuery("DELETE FROM accounts");
  }

  static Future<void> insert(String table, {required Map<String, Object> data}) async {
    Database db = await DBHelper.database();
    await db.insert(table, data, conflictAlgorithm: sql.ConflictAlgorithm.ignore);
  }

  static Future<List<Map<String, dynamic>>> getAccountActivated() async {
    Database db = await DBHelper.database();
    return await db.rawQuery("SELECT * FROM accounts ORDER BY createdAt DESC");
  }

  static Future<void> setAccountActive(String table, {required Map<String, dynamic> data}) async {
    Database db = await DBHelper.database();
    await db.insert(table, data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<void> update(String table, {required Map<String, dynamic> data}) async {
    Database db = await DBHelper.database();
    await db.update(table, {
      "id": "a",
      "name": data["name"],
      "status": "true"
    }, where: 'phone = ?', whereArgs: [data["phone"]], conflictAlgorithm: sql.ConflictAlgorithm.ignore); 
  }

  static Future<void> updateUsersStatus(String table, {required Map<String, dynamic> data}) async {
    Database db = await DBHelper.database();
    await db.update(table, {
      "id": "a",
      "name": data["name"],
      "status": "false"
    }, where: 'phone = ?', whereArgs: [data["phone"]], conflictAlgorithm: sql.ConflictAlgorithm.ignore); 
  }

  static Future<void> resetUsersStatus(String table) async {
    Database db = await DBHelper.database();
    await db.update(table, {
      "id": "b",
      "status": "false",
    }, conflictAlgorithm: sql.ConflictAlgorithm.ignore); 
  }

  static Future<void> resetBanksStatus(String table) async {
   Database db = await DBHelper.database();
    await db.delete(table);
  }

  static Future<void> delete(String table, {required String id}) async {
    Database db = await DBHelper.database();
    await db.delete(table, where: 'phone = ?', whereArgs: [id]);
  } 

   static Future<List<Map<String, dynamic>>> getAccountPaymentMethod() async {
    Database db = await DBHelper.database();
    return await db.rawQuery("SELECT * FROM banks");
  } 

  static Future<List<Map<String, dynamic>>> getUsers() async {
    Database db = await DBHelper.database();
    return await db.rawQuery("SELECT * FROM contacts ORDER BY id ASC");
  } 
  
  static Future<List<Map<String, dynamic>>> getUsersStatus() async {
    Database db = await DBHelper.database();
    return db.rawQuery("SELECT * FROM contacts WHERE status = 'true'");
  } 
}