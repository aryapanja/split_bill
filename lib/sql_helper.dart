import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE Person(
name TEXT,
balance DOUBLE)""");
    await database.execute("""CREATE TABLE Transactions(
      name TEXT,
      pay DOUBLE,
      selected TEXT,
      category TEXT
    )""");
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase('dbestech.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  static Future<int> createTransaction(
      String name, double pay, String selected, String category) async {
    final db = await SQLHelper.db();
    final data = {'name': name, 'pay': pay, 'selected': selected, 'category': category};
    final id = await db.insert('Transactions', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<int> createItem(String name, double? balance) async {
    final db = await SQLHelper.db();
    final data = {'name': name, 'balance': balance};
    final id = await db.insert('Person', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();
    return db.query('Person');
  }

  static Future<List<Map<String, dynamic>>> getTransactions() async {
    final db = await SQLHelper.db();
    return db.query('Transactions');
  }

  // static Future<List<Map<String, dynamic>>> getItem(String name) async {
  //   final db = await SQLHelper.db();
  //   return db.query('Person', where: "name = ?", whereArgs: [name], limit: 1);
  // }
  static Future<Map<String, dynamic>?> getItem(String name) async {
    final db = await SQLHelper.db();
    List<Map<String, dynamic>> result =
        await db.query('Person', where: "name = ?", whereArgs: [name]);
    return result.isNotEmpty ? result.first : null;
  }

  static Future<int> updateItem(String name, double? balance) async {
    final db = await SQLHelper.db();
    final data = {
      'name': name,
      'balance': balance,
    };
    final result =
        await db.update('Person', data, where: "name = ?", whereArgs: [name]);
    return result;
  }

  static Future<void> deleteItem(String name) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("items", where: "name= ?", whereArgs: [name]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

  static Future<void> removeAllRowsFromTable() async {
    final db = await SQLHelper.db();
    try {
      await db.delete('Person');
      await db.delete('Transactions');
    } catch (err) {
      debugPrint("Something went wrong when removing rows: $err");
    } finally {
      await db.close();
    }
  }
}
