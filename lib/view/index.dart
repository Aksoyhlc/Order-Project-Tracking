import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orderproject/const/ext.dart';
import 'package:orderproject/controller/state/sidebar_controller.dart';
import 'package:orderproject/view/home/index.dart';
import 'package:orderproject/view/shared/navbar.dart';
import 'package:orderproject/view/shared/sidebar.dart';

import '../const/const.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SidebarController sc = Get.find<SidebarController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backColor,
        body: Row(
          children: [
            const SideBar(),
            Expanded(
              child: Column(
                children: [
                  Navbar(),
                  Expanded(
                    child: Container(
                      //padding: EdgeInsets.symmetric(horizontal: isMobileSize() ? 10 : 25, vertical: isMobileSize() ? 10 : 25),
                      padding: EdgeInsets.only(
                        right: isMobileSize() ? 10 : 25,
                        left: isMobileSize() ? 10 : 25,
                        top: isMobileSize() ? 0 : 25,
                        bottom: isMobileSize() ? 0 : 25,
                      ),
                      child: Obx(
                        () => sc.page.value ?? HomeIndex(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
