import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orderproject/controller/state/sidebar_controller.dart';

class GlobalController extends GetxController {
  RxString title = "Order - Project Tracking".obs;
  RxBool loginCheck = false.obs;
  SidebarController sc = Get.find<SidebarController>();
  RxMap formData = {}.obs;
  RxMap<String, TextEditingController> dataController = {'x': TextEditingController()}.obs;
  RxList files = [].obs;
  RxList checkList = [].obs;
  RxBool allCheck = false.obs;
  RxBool filter = false.obs;
  RxString documentDirectory = "".obs;
}
