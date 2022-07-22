import 'package:sqflite/sqflite.dart';

import 'task.dart';

class TasksDB {
  static Database? _database;

  // Mình để các biến final để sau này chỉ cần đổi một chỗ thôi cho tiện
  static const String kTableName = 'taskTable';
  static const String kId = 'id';
  static const String kTitle = "title";
  static const String kTask = 'task';

  static const String kDate = "date";
  static const String kTime = "time";
  static const String kRemind = "remind";
  static const String kRepeat = "repeat";

  // Hàm mở database
  static Future<void> initDB() async {
    if (_database != null) {
      return;
    }
    try {
      String _path = await getDatabasesPath() + "tasks.db";
      _database = await openDatabase(
        _path,
        version: 1,
        onCreate: (db, version) {
          print("creating a new one");
          return db.execute(
            "CREATE TABLE $kTableName("
            "$kId INTEGER PRIMARY KEY AUTOINCREMENT, "
            "$kTitle TEXT, $kTask TEXT, $kDate STRING, "
            "$kTime STRING, $kRemind INTEGER, $kRepeat STRING, isCompleted INTEGER )",
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

  static Future<int> insert(Task? task) async {
    print("insert");
    return await _database?.insert(kTableName, task!.toJson()) ?? 1;
  }

  static Future<List<Map<String, dynamic>>> query() async {
    return await _database!.query(kTableName);
  }

  static delete(Task task) async {
    return await _database!
        .delete(kTableName, where: "id=?", whereArgs: [task.id]);
  }

  static update(int id) async {
    return await _database!
        .rawUpdate("UPDATE $kTableName SET isCompleted=? WHERE id=?", [1, id]);
  }

  static Future<List<Map<String, dynamic>>> findDate(String date) async {
    return await _database!.rawQuery(
        "SELECT * FROM $kTableName WHERE $kDate=? OR $kRepeat=?",
        [date, "Daily"]);
  }
}
