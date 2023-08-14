import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orderproject/const/const.dart';
import 'package:orderproject/controller/project_controller.dart';
import 'package:orderproject/controller/state/global_controller.dart';
import 'package:orderproject/model/project.dart';
import 'package:orderproject/view/partial/card.dart';
import 'package:orderproject/view/project/project_create_edit.dart';

import '../partial/record_head.dart';
import '../partial/table_widget.dart';

class Projects extends StatefulWidget {
  const Projects({Key? key}) : super(key: key);

  @override
  State<Projects> createState() => _ProjectsState();
}

class _ProjectsState extends State<Projects> {
  List<ProjectModel> rawList = [];
  final AsyncMemoizer _memoizer = AsyncMemoizer();
  ProjectController pc = ProjectController();
  TextEditingController searchController = TextEditingController();

  GlobalController gc = Get.find();
  //List<String> columns = ["ID", "Title", "Start Date", "End Date", "Status", "Urgency", "Progress", "Last Update"];
  List<Map<String, String>> columns = [
    {'data': 'ID', 'fixed': '50', 'id': "1"},
    {
      'data': 'title'.tr,
      'fixed': '150',
    },
    {
      'data': 'start_date'.tr,
      'fixed': '0',
    },
    {
      'data': 'End Date',
      'fixed': '0',
    },
    {'data': 'status'.tr, 'fixed': '0', 'filter': '1'},
    {'data': 'urgency'.tr, 'fixed': '0', 'filter': '1'},
    {'data': 'percent'.tr, 'fixed': '160', 'filter': '1'},
    {
      'data': 'last_update'.tr,
      'fixed': '0',
    },
    {'data': 'actions'.tr, 'fixed': '180', 'action': '1'},
  ];

  //List<List<String?>> rows = [];
  List<List<Map<String, String?>>> rows = [];

  _fetchData() async {
    return _memoizer.runOnce(() async {
      return await getData();
    });
  }

  Future<List<ProjectModel>> getData() async {
    rawList = await pc.cprojectList();
    rows.clear();
    for (int i = 0; i < rawList.length; i++) {
      rows.add(
        [
          {'data': rawList[i].id.toString(), 'type': 'text', 'id': "1"},
          {'data': rawList[i].title, 'type': 'text'},
          {'data': rawList[i].startDate, 'type': 'text'},
          {'data': rawList[i].endDate, 'type': 'text'},
          {'data': Status.values[rawList[i].status ?? 0].name.toLowerCase().tr, 'type': 'text'},
          {'data': Urgency.values[rawList[i].priority ?? 0].name.toLowerCase().tr, 'type': 'text'},
          {'data': rawList[i].percentage.toString(), 'type': 'progress'},
          {'data': rawList[i].lastUpdate?.split(".").first, 'type': 'string'},
        ],
      );
    }
    return rawList;
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      title: "projects".tr,
      headRightWidget: recordListHead(
        onPressed: () async {
          await pc.deleteProjectList(gc.checkList.map((e) => e.toString().split("_").last).toList());
          await getData();
          Get.back();

          setState(() {
            //tableKey.currentState?.upda;
          });
        },
        searchController: searchController,
      ),
      child: FutureBuilder(
        future: _fetchData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return TableWidget(
              key: UniqueKey(),
              type: "project",
              controller: searchController,
              columns: columns,
              rows: rows,
              deleteAction: (id) {
                Get.defaultDialog(
                  title: "project_delete".tr,
                  content: Text("delete_confirm".tr),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text("cancel".tr),
                    ),
                    TextButton(
                      onPressed: () async {
                        Get.back();
                        await pc.delete(id);
                        await getData();
                        setState(() {});
                      },
                      child: Text("delete".tr),
                    ),
                  ],
                );
              },
              editAction: (id) async {
                ProjectModel element = await pc.select(id);
                gc.sc.page.value = ProjectCreateEdit(project: element);
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
