import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orderproject/const/const.dart';
import 'package:orderproject/controller/state/sidebar_controller.dart';
import 'package:orderproject/view/project/project_create_edit.dart';
import 'package:orderproject/view/project/projects.dart';

import '../../const/ext.dart';
import '../customer/customer_create.dart';
import '../customer/customers.dart';
import '../order/create_edit.dart';
import '../order/orders.dart';
import '../partial/sidebar_menu_item.dart';

class SideBar extends StatefulWidget {
  const SideBar({Key? key}) : super(key: key);

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  SidebarController sc = Get.find<SidebarController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (sc.isDetail.value) {}
      return Visibility(
        visible: sc.isShow.value,
        child: FadeInLeft(
          duration: const Duration(milliseconds: 500),
          child: Container(
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: primaryColor,
                  blurRadius: 2,
                  offset: Offset(2, 0),
                ),
              ],
              gradient: LinearGradient(
                colors: [
                  primaryColor,
                  primaryColorDeep,
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
            height: double.infinity,
            width: isMobileSize()
                ? sc.isDetail.value
                    ? 0.45.sw
                    : 0.17.sw
                : 0.15.sw,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Image.asset("${imagePath}logo.png"),
                  ),
                  SidebarLineItem(
                    id: "home",
                    title: "home".tr,
                    icon: Icons.home_outlined,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10, right: 5, left: 5),
                    height: 1,
                    color: Colors.white.withOpacity(0.1),
                  ),
                  SidebarMenuItem(
                    title: "order".tr,
                    icon: Icons.shopping_cart_outlined,
                    id: "order",
                    items: [
                      SidebarMenuSubItem(
                        text: "order_create".tr,
                        onTap: () {
                          sc.pageChange(const OrderCreateEdit());
                        },
                      ),
                      SidebarMenuSubItem(
                        text: "orders".tr,
                        onTap: () {
                          sc.pageChange(const Orders());
                        },
                      ),
                    ],
                  ),
                  SidebarMenuItem(
                    title: "project".tr,
                    icon: Icons.work_outline,
                    id: "project",
                    items: [
                      SidebarMenuSubItem(
                        text: "project_create".tr,
                        onTap: () {
                          sc.pageChange(const ProjectCreateEdit());
                        },
                      ),
                      SidebarMenuSubItem(
                        text: "projects".tr,
                        onTap: () {
                          sc.pageChange(const Projects());
                        },
                      ),
                    ],
                  ),
                  SidebarMenuItem(
                    title: "customer".tr,
                    icon: Icons.people_outline,
                    id: "customer",
                    items: [
                      SidebarMenuSubItem(
                        text: "customer_create".tr,
                        onTap: () {
                          sc.pageChange(const CustomerCreate());
                        },
                      ),
                      SidebarMenuSubItem(
                        text: "customers".tr,
                        onTap: () {
                          sc.pageChange(const Customers());
                        },
                      ),
                    ],
                  ),
                  SidebarLineItem(
                    id: "profil",
                    title: "profil".tr,
                    icon: Icons.person_outline_outlined,
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 15, left: 15, top: 10),
                    child: Divider(color: Colors.white.withOpacity(0.1), height: 1),
                  ),
                  SidebarLineItem(
                    id: "logout",
                    title: "logout".tr,
                    icon: Icons.logout_outlined,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
