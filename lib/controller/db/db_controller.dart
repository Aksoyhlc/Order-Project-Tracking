import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:orderproject/controller/db/mobile_db.dart';
import 'package:orderproject/controller/db/other_platform_db.dart';

import '../../const/ext.dart';

class DB {
  MobileDB _mobileDB = MobileDB();
  OtherDB _otherDB = OtherDB();

  Future<List<Map<String, Object?>>> select(String sql) async {
    if (isMobile(mac: true)) {
      return await _mobileDB.select(sql);
    } else {
      return await _otherDB.select(sql);
    }
  }

  Future<bool> insert(String dbName, Map<String, dynamic> data) async {
    if (isMobile(mac: true)) {
      return await _mobileDB.insert(dbName, data);
    } else {
      return await _otherDB.insert(dbName, data);
    }
  }

  Future<bool> updateData(String dbName, Map<String, dynamic> data, String where) async {
    if (isMobile(mac: true)) {
      return await _mobileDB.updateData(dbName, data, where);
    } else {
      return await _otherDB.updateData(dbName, data, where);
    }
  }

  Future<bool> delete(String dbName, List<String> colNames, List<dynamic> variables) async {
    if (isMobile(mac: true)) {
      return await _mobileDB.delete(dbName, colNames, variables);
    } else {
      return await _otherDB.delete(dbName, colNames, variables);
    }
  }

  Future<void> rawQuery(String sql) async {
    if (isMobile(mac: true)) {
      await _mobileDB.select(sql);
    } else {
      await _otherDB.select(sql);
    }
  }

  Future<String?> getSettings(String key) async {
    late List<Map<String, Object?>> result;
    String query = "SELECT * FROM settings WHERE key='$key'";

    if (isMobile(mac: true)) {
      result = await _mobileDB.select(query);
    } else {
      result = await _otherDB.select(query);
    }

    if (result.isEmpty) {
      return null;
    }

    return result.first["value"].toString();
  }

  Future<String?> setSettings(String key, String value) async {
    String? val = await getSettings(key);
    String query = "";

    if (val == null) {
      query = "INSERT INTO settings (key,value) VALUES('$key','$value')";
    } else {
      query = "UPDATE settings SET value='$value' WHERE key='$key'";
    }

    if (isMobile(mac: true)) {
      await _mobileDB.select(query);
      return "";
    } else {
      await _otherDB.select(query);
      return "";
    }
  }

  Future<void> deleteSettings(String key) async {
    String query = "DELETE FROM settings WHERE key='$key'";

    if (isMobile(mac: true)) {
      await _mobileDB.select(query);
    } else {
      await _otherDB.select(query);
    }
  }

  hashPassword(String password) {
    return sha256.convert(utf8.encode(md5.convert(utf8.encode(password)).toString())).toString();
  }
}
