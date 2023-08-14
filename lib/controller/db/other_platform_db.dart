import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

class OtherDB {
  Future<Database> init() async {
    String path = (await getApplicationSupportDirectory()).path + "/db.db";
    if (!File(path).existsSync()) {
      ByteData data = await rootBundle.load("assets/db/db.db");
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
    }

    Database db = await sqlite3.open(path);
    return db;
  }

  Future<List<Map<String, Object?>>> select(String sql) async {
    try {
      Database db = await init();
      var result = db.select(sql);
      db.dispose();
      return result;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<bool> insert(String dbName, Map<String, dynamic> data) async {
    try {
      Database db = await init();
      db
          .prepare("INSERT INTO $dbName (" +
              data.keys.toList().join(", ") +
              ") VALUES (" +
              data.values.map((e) => "?").toList().join(", ")
              //textRepeat("?,", data.keys.length)
              +
              ") ")
          .execute(data.values.toList());

      db.dispose();

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> updateData(String dbName, Map<String, dynamic> data, String where) async {
    try {
      Database db = await init();
      db.prepare("UPDATE $dbName SET " + data.keys.map((e) => "$e = ?").toList().join(", ") + " WHERE $where").execute(data.values.toList());
      db.dispose();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> delete(String dbName, List<String> colNames, List<dynamic> variables) async {
    try {
      Database db = await init();
      String where = colNames.map((e) => "$e = ?").toList().join(" AND ");
      db.prepare("DELETE FROM $dbName WHERE $where").execute(variables);
      db.dispose();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
