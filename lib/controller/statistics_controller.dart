import 'package:get/get.dart';
import 'package:orderproject/const/const.dart';

import 'db/db_controller.dart';
import 'state/global_controller.dart';

class Statistics {
  GlobalController gc = Get.find();
  DB db = DB();

  Future<String> getSingleData(String dbName, String? select, String? where) async {
    select = select ?? "COUNT(id) as value";
    String query = "SELECT $select FROM $dbName";
    if (where != null) {
      query += " WHERE $where";
    }
    List<Map<String, Object?>> data = await db.select(query);
    return data[0]["value"].toString();
  }

  Future<Map<String, String>> getMonthlyData(String table, String column, String? year, String? select) async {
    String currentYear = year ?? DateTime.now().year.toString();
    select = select ?? "COUNT(*)";

    Map<String, String> resultData = {};
    String month = "";
    String monthString = "";

    for (int i = 1; i <= 12; i++) {
      month = i.toString();
      monthString = MonthList[i - 1];
      if (i.toString().length == 1) {
        month = "0$i";
      }
      String query =
          "SELECT $select AS value FROM $table WHERE $column BETWEEN '$currentYear-$month-01 00:00:00' AND '$currentYear-$month-31 23:59:59';";

      var projectResult = await db.select(query);
      resultData[monthString] = projectResult[0]["value"].toString();
    }
    return resultData;
  }
}
