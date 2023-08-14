import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orderproject/const/const.dart';
import 'package:orderproject/controller/order_controller.dart';
import 'package:orderproject/controller/state/global_controller.dart';
import 'package:orderproject/model/order.dart';
import 'package:orderproject/view/order/create_edit.dart';
import 'package:orderproject/view/partial/card.dart';

import '../partial/record_head.dart';
import '../partial/table_widget.dart';

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  List<OrderModel> rawList = [];
  List<List<Map<String, String?>>> rows = [];
  GlobalController gc = Get.find();
  final AsyncMemoizer _memoizer = AsyncMemoizer();
  OrderController oc = OrderController();
  TextEditingController searchController = TextEditingController();

  //List<String> columns = ["ID", "Title", "Start Date", "End Date", "Status", "Urgency", "Progress", "Last Update"];
  List<Map<String, String>> columns = [
    {'data': 'ID', 'fixed': '50', 'id': "1"},
    {'data': 'title'.tr, 'fixed': '0'},
    {'data': 'name'.tr, 'fixed': '0', 'filter': '1'},
    {'data': 'phone'.tr, 'fixed': '0', 'filter': '1'},
    {'data': 'urgency'.tr, 'fixed': '0', 'filter': '1'},
    {'data': 'status'.tr, 'fixed': '0', 'filter': '1'},
    {'data': 'percent'.tr, 'fixed': '160', 'filter': '1'},
    {'data': 'price'.tr, 'fixed': '0'},
    {'data': 'start_date'.tr, 'fixed': '0'},
    {'data': 'end_date'.tr, 'fixed': '0'},
    //{'data': 'last_update'.tr, 'fixed': '0'},
    {'data': 'actions'.tr, 'fixed': '180', 'action': '1'},
  ];

  _fetchData() async {
    return _memoizer.runOnce(() async {
      return await getData();
    });
  }

  Future<List<OrderModel>> getData() async {
    rawList = await oc.orderList();
    rows.clear();
    for (int i = 0; i < rawList.length; i++) {
      rows.add(
        [
          {'data': rawList[i].id.toString(), 'id': '1'},
          {'data': rawList[i].title},
          {'data': rawList[i].customerData?.name ?? ""},
          {'data': rawList[i].customerData?.phone ?? ""},
          {'data': Urgency.values[rawList[i].urgency ?? 0].name.toLowerCase().tr},
          {'data': Status.values[rawList[i].status ?? 0].name.toLowerCase().tr},
          {'data': rawList[i].percentage.toString(), 'type': 'progress'},
          {'data': rawList[i].price.toString()},
          {'data': rawList[i].startDate.toString().split(" ")[0]},
          {'data': rawList[i].deliveryDate.toString().split(" ")[0]},
          //{'data': rawList[i].lastupdate.toString().split(".").first},
        ],
      );
    }
    return rawList;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      title: "orders".tr,
      headRightWidget: recordListHead(
        onPressed: () async {
          await oc.deleteOrderList(gc.checkList.map((e) => e.toString().split("_").last).toList());
          await getData();
          Get.back();

          setState(() {});
        },
        searchController: searchController,
      ),
      child: FutureBuilder(
        future: _fetchData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return TableWidget(
              key: UniqueKey(),
              type: "orders",
              controller: searchController,
              columns: columns,
              rows: rows,
              deleteAction: (id) {
                Get.defaultDialog(
                  title: "order_delete".tr,
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
                        await oc.deleteOrder(id);
                        await getData();
                        setState(() {});
                      },
                      child: Text("delete".tr),
                    ),
                  ],
                );
              },
              editAction: (id) async {
                OrderModel element = await oc.select(id);
                gc.sc.page.value = OrderCreateEdit(order: element);
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
