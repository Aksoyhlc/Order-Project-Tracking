import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MobileDB {
  Database? db;

  Future<void> init() async {
    try {
      String dbPath = await getDatabasesPath();
      String path = dbPath + "/db.db";

      if (File(path).existsSync()) {
        db = await openDatabase(path, readOnly: false);
      } else {
        try {
          await Directory(dirname(path)).create(recursive: true);
        } catch (_) {}

        ByteData data = await rootBundle.load("assets/db/db.db");
        List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

        await File(path).writeAsBytes(bytes, flush: true);
        db = await openDatabase(path, readOnly: false);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<List<Map<String, Object?>>> select(String sql) async {
    try {
      await init();
      if (db == null) {
        throw Exception("DB init not working!");
      }

      return await db!.rawQuery(sql);
    } catch (e) {
      print(e);
      return [];
    } finally {
      //db?.close();
    }
  }

  Future<bool> insert(String dbName, Map<String, dynamic> data) async {
    try {
      await init();

      if (db == null) {
        throw Exception("DB init not working!");
      }

      db!.execute(
          "INSERT INTO $dbName (" +
              data.keys.toList().join(", ") +
              ") VALUES (" +
              data.values.map((e) => "?").toList().join(", ")
              //textRepeat("?,", data.keys.length)
              +
              ") ",
          data.values.toList());
      return true;
    } catch (e) {
      print(e);
      return false;
    } finally {
      //db?.close();
    }
  }

  Future<bool> updateData(String dbName, Map<String, dynamic> data, String where) async {
    try {
      await init();

      if (db == null) {
        throw Exception("DB init not working!");
      }

      db!.execute("UPDATE $dbName SET " + data.keys.map((e) => "$e = ?").toList().join(", ") + " WHERE $where", data.values.toList());
      return true;
    } catch (e) {
      print(e);
      return false;
    } finally {
      //db?.close();
    }
  }

  Future<bool> delete(String dbName, List<String> colNames, List<dynamic> variables) async {
    try {
      await init();

      if (db == null) {
        throw Exception("DB init not working!");
      }

      String where = colNames.map((e) => "$e = ?").toList().join(" AND ");
      db!.execute("DELETE FROM $dbName WHERE $where", variables);
      return true;
    } catch (e) {
      print(e);
      return false;
    } finally {
      //db?.close();
    }
  }
}
