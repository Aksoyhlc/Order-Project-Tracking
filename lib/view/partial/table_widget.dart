import 'package:animate_do/animate_do.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:orderproject/view/partial/dropdown.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../Const/const.dart';
import '../../const/ext.dart';
import '../../controller/state/global_controller.dart';
import 'icon_text_button.dart';

class TableWidget extends StatefulWidget {
  final String type;
  final TextEditingController controller;
  final List<Map<String, String>> columns;
  final List<List<Map<String, String?>>> rows;
  final Function(int id) editAction;
  final Function(int id) deleteAction;
  final double largeScreenMaxSize;

  const TableWidget({
    super.key,
    required this.type,
    required this.controller,
    required this.columns,
    required this.rows,
    required this.editAction,
    required this.deleteAction,
    this.largeScreenMaxSize = 1600,
  });

  @override
  State<TableWidget> createState() => _TableWidgetState();
}

class _TableWidgetState extends State<TableWidget> {
  List<DataRow> list = [];
  bool _isSortAscending = true;
  int _sortIndex = 1;
  List<List<Map<String, String?>>> rawRows = [];
  List<List<Map<String, String?>>> resultRows = [];
  List<Map<String, String>> columns = [];
  GlobalController gc = Get.find<GlobalController>();
  List<Map<String, dynamic>> filterRow = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateData();
  }

  void updateData() {
    rawRows.addAll(widget.rows);
    resultRows.addAll(widget.rows);
    columns.addAll(widget.columns);
    columns.insert(0, {'data': '#', 'fixed': '50'});
    filterRowDataBuild();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      gc.checkList.clear();
    });

    widget.controller.addListener(() {
      resultRows = [];
      for (List<Map<String, String?>> row in rawRows) {
        for (Map<String, String?> cell in row) {
          if (cell['data'].toString().toLowerCase().contains(widget.controller.text.toLowerCase())) {
            resultRows.add(row);
            break;
          }
        }
      }
      filterRowDataBuild();
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() {
          if (gc.filter.value) {
            return ZoomIn(duration: Duration(milliseconds: 500), child: filterRowBuild());
          }
          return SizedBox();
        }),
        Expanded(
          child: DataTable2(
            columnSpacing: 12,
            horizontalMargin: 12,
            minWidth: isMobileSize() ? Get.width * 2.5 : widget.largeScreenMaxSize,
            dataRowHeight: 50,
            sortArrowIcon: Icons.arrow_downward,
            sortAscending: _isSortAscending,
            sortColumnIndex: _sortIndex,
            border: TableBorder.all(),
            isHorizontalScrollBarVisible: true,
            isVerticalScrollBarVisible: true,
            headingRowColor: MaterialStateColor.resolveWith((states) {
              return primaryColor;
            }),
            headingTextStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            dataTextStyle: GoogleFonts.quicksand(
              color: greyColor,
            ),
            columns: List.generate(
              columns.length,
              (index) {
                double? fixedWidth;
                if (columns[index]['fixed'] == '0') {
                  fixedWidth = null;
                } else if (columns[index]['action'] == '1') {
                  fixedWidth = 200;
                } else {
                  fixedWidth = double.parse(columns[index]['fixed'].toString());
                }

                return DataColumn2(
                  //size: index == 0 ? ColumnSize.S : ColumnSize.M,
                  fixedWidth: fixedWidth,
                  label: columns[index]['data'] == "#"
                      ? Obx(() {
                          return Checkbox(
                            value: gc.allCheck.value,
                            onChanged: (value) {
                              gc.allCheck.value = value ?? false;
                              allRowCheck(value);
                            },
                          );
                        })
                      : Text(columns[index]['data'].toString()),
                  onSort: columns[index]['data'] == "#" ? null : sort,
                );
              },
            ),
            rows: rowGenereate(),
          ),
        ),
      ],
    );
  }

  List<DataRow> rowGenereate() {
    List<DataRow> list = [];
    for (var el in resultRows) {
      list.add(DataRow(cells: cellGenerate(el)));
    }
    return list;
  }

  List<DataCell> cellGenerate(List<Map<String, String?>> tmpRow) {
    List<Map<String, String?>> row = List.from(tmpRow);

    List<DataCell> list = List.generate(row.length + 2, (index) => DataCell(Text('')));
    int id = int.tryParse(row.where((element) => element['id'] != null).first['data'].toString()) ?? 0;
    int actionIndex = columns.indexWhere((e) => e['action'] == '1');
    row.insert(0, {'data': 'ch', 'fixed': ''});
    row.insert(actionIndex, {'data': 'ac', 'fixed': ''});

    for (int i = 0; i < row.length; i++) {
      Map<String, String?> el = row[i];

      if (el['data'] == 'ch') {
        list[i] = DataCell(
          Obx(() {
            return Checkbox(
              value: gc.checkList.contains("${widget.type}_$id"),
              onChanged: (value) {
                if (value == true) {
                  gc.checkList.add("${widget.type}_$id");
                } else {
                  gc.checkList.remove("${widget.type}_$id");
                }
              },
            );
          }),
        );
      } else if (el['data'] == 'ac') {
        list[i] = DataCell(
          Container(
            alignment: Alignment.center,
            child: Wrap(
              alignment: WrapAlignment.center,
              children: [
                iconTextButton(
                  color: greenColor,
                  icon: Icons.edit,
                  text: "edit".tr,
                  onTap: () {
                    widget.editAction(id);
                  },
                ),
                const SizedBox(width: 8),
                iconTextButton(
                  color: redColor,
                  icon: Icons.clear_outlined,
                  text: "delete".tr,
                  onTap: () {
                    widget.deleteAction(id);
                  },
                ),
              ],
            ),
          ),
        );
      } else {
        list[i] = DataCell(
          el['type'] == 'progress'
              ? progressData(el['data'].toString())
              : SelectableText(
                  el['data'].toString(),
                ),
        );
      }
    }

    return list;
  }

  Widget progressData(String data) {
    double deger = (double.tryParse(data) ?? 0) / 100;
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearPercentIndicator(
              width: 140,
              animation: true,
              lineHeight: 15,
              animationDuration: 1000,
              percent: deger > 1 ? 1 : deger,
              center: Text(
                "$data%",
                style: const TextStyle(
                  fontSize: 12,
                  color: whiteColor,
                ),
              ),
              //linearStrokeCap: LinearStrokeCap.roundAll,
              barRadius: const Radius.circular(100),
              progressColor: primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  void sort(columnIndex, ascending) {
    setState(() {
      _isSortAscending = ascending;
      _sortIndex = columnIndex;
      resultRows.sort((a, b) => a[columnIndex]['data'].toString().compareTo(b[columnIndex]['data'].toString()));
      if (!ascending) {
        resultRows = resultRows.reversed.toList();
      }
    });
  }

  void allRowCheck(bool? value) {
    for (List<Map<String, String?>> row in resultRows) {
      var cell = row.where((element) => (element['id'] ?? "") == '1').first;
      if (value ?? false) {
        if (!gc.checkList.contains("${widget.type}_${cell['data']}")) {
          gc.checkList.add("${widget.type}_${cell['data']}");
        }
      } else {
        gc.checkList.remove("${widget.type}_${cell['data']}");
      }
    }
  }

  void filterRowDataBuild() {
    filterRow = [];
    for (int i = 0; i <= columns.length - 1; i++) {
      int colIndex = i;
      var element = columns[i];
      if (colIndex == 0 || colIndex == 1) {
        filterRow.add({
          'title': null,
          'index': null,
          'data': null,
        });
      } else if (colIndex == columns.length - 1) {
        filterRow.add({
          'title': null,
          'index': null,
          'data': null,
        });
      } else {
        colIndex = colIndex - 1;
        //print("Col length: ${columns.length} - ColIndex: ${colIndex} - RawRows: ${rawRows[0].length}");

        filterRow.add({
          'title': element['data'],
          'index': colIndex,
          'filter': element['filter'].toString(),
          'data': Map.fromIterable(rawRows.map((e) => e[colIndex]['data']).toList()),
        });
      }
    }
  }

  Widget filterRowBuild() {
    filterRowDataBuild();
    List<Widget> items = [];

    for (int i = 0; i <= filterRow.length - 1; i++) {
      var element = filterRow[i];
      if (element['title'] == null || element['filter'] != "1") {
        //items.add(Container());
      } else if (element == "" || (element['title'] ?? "") == "") {
      } else {
        Map<String, String> editData = {};
        filterRow[i]['data'].forEach((anahtar, deger) {
          if ((deger ?? "") != "") {
            editData[anahtar as String] = deger as String;
          }
        });
        editData['allData'] = "all_data".tr;
        items.add(
          Container(
            margin: const EdgeInsets.only(right: 10, bottom: 15),
            child: CustomDropDownMenu(
              items: editData,
              selectKey: "0",
              label: element['title'].toString(),
              onSelect: (key, value) {
                setState(() {
                  if (key == "allData") {
                    resultRows = rawRows;
                    return;
                  }

                  resultRows = rawRows.where((row) => row[filterRow[i]['index']]['data'] == value).toList();
                });
              },
            ),
          ),
        );
      }
    }

    return Wrap(children: items);
  }
}
