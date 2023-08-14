import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SidebarController extends GetxController {
  RxString selectedMenu = "".obs;
  var page = Rxn<Widget>();
  RxBool isDetail = false.obs;
  RxBool isShow = true.obs;

  void pageChange(Widget page) {
    this.page.value = page;
  }

  void changeSidebar() {
    isShow.value = !isShow.value;
  }

  bool getStatus(String id) {
    bool status = false;
    return status;
  }

  void open(String id) {
    if (id == selectedMenu.value) {
      closeAll();
      return;
    }

    selectedMenu.value = id;
    isDetail.value = true;
  }

  void close(String id) {
    isDetail.value = false;
  }

  void closeAll() {
    selectedMenu.value = "";
    isDetail.value = false;
  }
}
