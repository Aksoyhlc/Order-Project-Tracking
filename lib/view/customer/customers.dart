import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orderproject/controller/customer_controller.dart';
import 'package:orderproject/model/customer.dart';
import 'package:orderproject/view/customer/customer_create.dart';

import '../../controller/state/global_controller.dart';
import '../partial/card.dart';
import '../partial/record_head.dart';
import '../partial/table_widget.dart';

class Customers extends StatefulWidget {
  const Customers({Key? key}) : super(key: key);

  @override
  State<Customers> createState() => _CustomersState();
}

class _CustomersState extends State<Customers> {
  List<CustomerModel> rawList = [];
  final AsyncMemoizer _memoizer = AsyncMemoizer();
  CustomerController cc = CustomerController();
  TextEditingController searchController = TextEditingController();

  GlobalController gc = Get.find();

  //List<String> columns = ["ID", "Title", "Start Date", "End Date", "Status", "Urgency", "Progress", "Last Update"];
  List<Map<String, String>> columns = [
    {'data': 'ID', 'fixed': '50', 'id': "1"},
    {
      'data': 'name'.tr,
      'fixed': '0',
    },
    {
      'data': 'phone'.tr,
      'fixed': '0',
    },
    {
      'data': 'Mail',
      'fixed': '0',
    },
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

  Future<List<CustomerModel>> getData() async {
    rawList = await cc.customerList();
    rows.clear();
    for (int i = 0; i < rawList.length; i++) {
      rows.add(
        [
          {'data': rawList[i].cusId.toString(), 'type': 'text', 'id': "1"},
          {'data': rawList[i].name ?? "", 'type': 'text'},
          {'data': rawList[i].phone ?? "", 'type': 'text'},
          {'data': rawList[i].mail ?? "", 'type': 'text'},
          {'data': rawList[i].lastupdate?.split(".").first, 'type': 'string'},
        ],
      );
    }
    return rawList;
  }

  final GlobalKey<State> tableKey = GlobalKey<State>();
  @override
  Widget build(BuildContext context) {
    return CustomCard(
      title: "customers".tr,
      headRightWidget: recordListHead(
        onPressed: () async {
          await cc.deleteCustomerList(gc.checkList.map((e) => e.toString().split("_").last).toList());
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
              largeScreenMaxSize: 1000,
              key: UniqueKey(),
              type: "customers",
              controller: searchController,
              columns: columns,
              rows: rows,
              deleteAction: (id) {
                Get.defaultDialog(
                  title: "customer_delete".tr,
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
                        await cc.deleteCustomer(id);
                        await getData();
                        setState(() {});
                      },
                      child: Text("delete".tr),
                    ),
                  ],
                );
              },
              editAction: (id) async {
                CustomerModel element = await cc.select(id);
                gc.sc.page.value = CustomerCreate(customer: element);
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
