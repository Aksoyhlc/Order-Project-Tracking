import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orderproject/view/partial/table_search_widget.dart';

import '../../Const/const.dart';
import '../../controller/state/global_controller.dart';
import 'icon_text_button.dart';

Widget recordListHead({required TextEditingController searchController, required Function() onPressed, bool filter = true}) {
  GlobalController gc = Get.find();
  return Wrap(
    crossAxisAlignment: WrapCrossAlignment.center,
    children: [
      Obx(() {
        if (gc.checkList.isNotEmpty) {
          return iconTextButton(
            icon: Icons.clear,
            text: "delete_selected".tr,
            onTap: () {
              Get.defaultDialog(
                title: "delete_selected".tr,
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
                      onPressed();

                      Get.back();
                    },
                    child: Text("delete".tr),
                  ),
                ],
              );
            },
            color: redColor,
          );
        } else {
          return const SizedBox();
        }
      }),
      const SizedBox(width: 10),
      tableSearchWidget(searchController),
      if (filter)
        InkWell(
          onTap: () {
            gc.filter.value = !gc.filter.value;
          },
          child: Container(
            padding: EdgeInsets.all(5),
            child: Obx(() {
              return Icon(
                gc.filter.value ? Icons.filter_alt : Icons.filter_alt_outlined,
                color: primaryColor,
              );
            }),
          ),
        ),
    ],
  );
}
