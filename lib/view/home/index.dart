import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orderproject/const/const.dart';

import '../../const/ext.dart';
import '../../controller/statistics_controller.dart';
import '../statistics/chart/chart_data.dart';
import '../statistics/chart/column_chart.dart';
import 'widget/stat_card.dart';

class HomeIndex extends StatefulWidget {
  const HomeIndex({Key? key}) : super(key: key);

  @override
  State<HomeIndex> createState() => _HomeIndexState();
}

class _HomeIndexState extends State<HomeIndex> {
  final AsyncMemoizer _memoizer = AsyncMemoizer();
  Statistics st = Statistics();

  fetchData() async {
    return _memoizer.runOnce(() async {
      await getData();
      return true;
    });
  }

  List<Map<String, dynamic>> projectCardData = [];
  List<Map<String, dynamic>> orderCardData = [];
  Map<String, Map<String, List<Widget>>> data = {};

  List<Map<String, dynamic>> cardData = [
    {
      "group": "0",
      "title": "total_project".tr,
      "value": "100",
      "icon": Icons.folder_open_outlined,
      "color": primaryColor,
      "data": {
        "table": "project",
        "select": null,
        "where": null,
      }
    },
    {
      "group": "0",
      "title": "completed_project".tr,
      "value": "100",
      "icon": Icons.check_circle_outline,
      "color": greenColor,
      "data": {
        "table": "project",
        "select": null,
        "where": "status = ${Status.Completed.index}",
      }
    },
    {
      "group": "0",
      "title": "cancelled_project".tr,
      "value": "100",
      "icon": Icons.cancel_outlined,
      "color": redColor,
      "data": {
        "table": "project",
        "select": null,
        "where": "status = ${Status.Cancelled.index}",
      }
    },
    {
      "group": "0",
      "title": "continues_project".tr,
      "value": "100",
      "icon": Icons.keyboard_double_arrow_right,
      "color": infoColor,
      "data": {
        "table": "project",
        "select": null,
        "where": "status = ${Status.Continues.index}",
      }
    },
    {
      "group": "1",
      "title": "total_order".tr,
      "value": "100",
      "icon": Icons.shopping_cart_outlined,
      "color": primaryColor,
      "data": {
        "table": "orders",
        "select": null,
        "where": null,
      }
    },
    {
      "group": "1",
      "title": "completed_order".tr,
      "value": "100",
      "icon": Icons.check_circle_outline,
      "color": greenColor,
      "data": {
        "table": "orders",
        "select": null,
        "where": "status = ${Status.Completed.index}",
      }
    },
    {
      "group": "1",
      "title": "cancelled_order".tr,
      "value": "100",
      "icon": Icons.cancel_outlined,
      "color": redColor,
      "data": {
        "table": "orders",
        "select": null,
        "where": "status = ${Status.Cancelled.index}",
      }
    },
    {
      "group": "1",
      "title": "continues_order".tr,
      "value": "100",
      "icon": Icons.keyboard_double_arrow_right,
      "color": infoColor,
      "data": {
        "table": "orders",
        "select": null,
        "where": "status = ${Status.Continues.index}",
      }
    },
  ];

  List<Map<String, dynamic>> chartData = [
    {
      "group": "0",
      "title": "previous_year_project".tr,
      "color": redColor,
      "value": [],
      "data": {
        "table": "project",
        "column": "created_date",
        "year": (DateTime.now().year - 1).toString(),
        "select": null,
      }
    },
    {
      "group": "0",
      "title": "this_year_project".tr,
      "color": greenColor,
      "value": [],
      "data": {
        "table": "project",
        "column": "created_date",
        "year": (DateTime.now().year).toString(),
        "select": null,
      }
    },
    {
      "group": "1",
      "title": "previous_year_order".tr,
      "color": infoColor,
      "value": [],
      "data": {
        "table": "orders",
        "column": "created_date",
        "year": (DateTime.now().year - 1).toString(),
        "select": null,
      }
    },
    {
      "group": "1",
      "title": "this_year_order".tr,
      "color": primaryColor,
      "value": [],
      "data": {
        "table": "orders",
        "column": "created_date",
        "year": (DateTime.now().year).toString(),
        "select": null,
      }
    },
  ];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  children: List.generate(
                    cardData.map((e) => e['group']).toSet().toList().length,
                    (index) {
                      var chartList = chartData.where((element) => element['group'] == index.toString()).toList();
                      var cardList = cardData.where((element) => element['group'] == index.toString()).toList();
                      return Container(
                        margin: const EdgeInsets.only(bottom: 30),
                        child: Wrap(
                          children: [
                            SizedBox(
                              width: Get.width,
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                spacing: 10,
                                children: List.generate(
                                  (cardList).length,
                                  (index2) {
                                    return StatCard(
                                      color: cardList[index2]["color"],
                                      title: cardList[index2]["title"],
                                      value: cardList[index2]["value"],
                                      icon: cardList[index2]["icon"],
                                    );
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              width: Get.width,
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                children: List.generate(
                                  (chartList).length,
                                  (index3) {
                                    return ColumnChart(
                                      title: chartList[index3]["title"],
                                      color: chartList[index3]["color"],
                                      data: chartList[index3]["value"],
                                      year: chartList[index3]["data"]["year"] ?? "",
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        } else {
          return loading();
        }
      },
    );
  }

  Map<String, Map<String, List<Widget>>> cardGenerator() {
    //List<Widget> cardList = [];
    String group = "0";
    data.clear();

    for (var i = 0; i < cardData.length; i++) {
      Map<String, dynamic> item = cardData[i];
      group = item["group"];
      if (data[group] == null) {
        data[group] = {};
      }

      if (data[group]?['card'] == null) {
        data[group]?['card'] = [];
      }

      if (data[group]?['chart'] == null) {
        data[group]?['chart'] = [];
      }

      data[group]?['card']!.add(
        StatCard(
          color: item["color"],
          title: item["title"],
          value: item["value"],
          icon: item["icon"],
        ),
      );
    }

    return data;
  }

  Future<void> getData() async {
    for (var i = 0; i < cardData.length; i++) {
      Map<String, dynamic> item = cardData[i];
      String table = item["data"]["table"];
      String? select = item["data"]["select"];
      String? where = item["data"]["where"];
      String value = await st.getSingleData(table, select, where);
      cardData[i]["value"] = value;
    }

    for (var i = 0; i < chartData.length; i++) {
      Map<String, dynamic> item = chartData[i];
      String table = item["data"]["table"];
      String column = item["data"]["column"];
      String? year = item["data"]["year"];
      String? select = item["data"]["select"];
      Map<String, dynamic> mapData = await st.getMonthlyData(table, column, year, select);

      List<ChartData> value = [];
      mapData.forEach((key, val) {
        value.add(ChartData(key, double.tryParse(val.toString()) ?? 0));
      });
      chartData[i]["value"] = value;
    }
  }
}
