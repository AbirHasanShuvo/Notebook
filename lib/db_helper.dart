import 'package:sqflite/sqflite.dart' as sql;
import 'package:flutter/cupertino.dart';

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE items(
       id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        type TEXT,
        title TEXT,
        description TEXT,
        color INTEGER NOT NULL,
        date TEXT
      )""");
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase("notebook.db", version: 2,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  static Future<int> createData(
      String type, String title, String? description, int color, String date) async {
    final db = await SQLHelper.db();
    final data = {
      'type': type,
      'title': title,
      'description': description,
      'color': color,
      'date' : date
    };

    final id = await db.insert('items', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);

    return id;
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();
    return db.query('items', orderBy: 'id');
  }

  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelper.db();
    return db.query('items', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<int> upDateItem(
      int id, String type, String title, String description, int color, String date) async {
    final db = await SQLHelper.db();

    final data = {
      'type': type,
      'title': title,
      'description': description,
      'color': color,
      'date' : date

    };

    final result =
        await db.update('items', data, where: "id = ?", whereArgs: [id]);

    return result;
  }

  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();

    try {
      await db.delete("items", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong : $err ");
    }
  }
}
