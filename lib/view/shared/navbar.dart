import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orderproject/Const/const.dart';
import 'package:orderproject/controller/state/sidebar_controller.dart';

class Navbar extends StatelessWidget {
  Navbar({Key? key}) : super(key: key);

  SidebarController sc = Get.find<SidebarController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        /* boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],*/
      ),
      margin: const EdgeInsets.only(left: 5),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              sc.changeSidebar();
            },
            child: Container(
              height: 50,
              width: 50,
              child: const Icon(
                Icons.menu,
                color: greyColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
