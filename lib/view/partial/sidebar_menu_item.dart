import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:orderproject/const/ext.dart';
import 'package:orderproject/controller/state/sidebar_controller.dart';
import 'package:orderproject/view/home/index.dart';
import 'package:orderproject/view/profil/profil.dart';

import '../../controller/user_controller.dart';

class SidebarMenuItem extends StatefulWidget {
  final String id;
  final String title;
  final IconData icon;
  final List<SidebarMenuSubItem> items;

  const SidebarMenuItem({
    Key? key,
    required this.id,
    required this.title,
    required this.icon,
    required this.items,
  }) : super(key: key);

  //const SidebarMenu({Key? key}) : super(key: key);

  @override
  State<SidebarMenuItem> createState() => _SidebarMenuItemState();
}

class _SidebarMenuItemState extends State<SidebarMenuItem> {
  SidebarController sc = Get.find();
  bool isOpen = false;
  Color color = Colors.white.withOpacity(0.8);
  double iconSize = 20;
  double textSize = 17;

  @override
  Widget build(BuildContext context) {
    iconSize = isMobileSize() ? 25 : 20;
    return Obx(() {
      isOpen = sc.selectedMenu.value == widget.id;
      return Container(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                sc.open(widget.id);
              },
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: isMobileSize() ? MainAxisAlignment.center : MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: isMobileSize() ? 0 : 10),
                        child: Icon(
                          widget.icon,
                          color: color,
                          size: iconSize,
                        ),
                      ),
                      if (!isMobileSize())
                        Expanded(
                          child: Text(
                            widget.title,
                            style: GoogleFonts.quicksand(
                              color: color,
                              fontSize: textSize,
                            ),
                          ),
                        ),
                      if (!isMobileSize())
                        Container(
                          alignment: Alignment.centerRight,
                          child: Icon(
                            isOpen ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
                            color: color,
                            size: iconSize + 2,
                          ),
                        )
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    height: 1,
                    color: color.withOpacity(0.1),
                  ),
                ],
              ),
            ),
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 300),
              crossFadeState: !isOpen ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              firstChild: DefaultTextStyle(
                style: GoogleFonts.quicksand(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  margin: const EdgeInsets.only(top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          "Actions:",
                          style: GoogleFonts.quicksand(
                            color: Colors.grey.shade400,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: widget.items,
                      )
                    ],
                  ),
                ),
              ),
              secondChild: Container(),
            )
          ],
        ),
      );
    });
  }
}

class SidebarMenuSubItem extends StatelessWidget {
  final String text;
  final Function() onTap;

  const SidebarMenuSubItem({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
        SidebarController sc = Get.find();
        sc.closeAll();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: Text(
          text,
          textAlign: TextAlign.start,
        ),
      ),
    );
  }
}

class SidebarLineItem extends StatefulWidget {
  final String id;
  final String title;
  final IconData icon;

  const SidebarLineItem({
    Key? key,
    required this.id,
    required this.title,
    required this.icon,
  }) : super(key: key);

  @override
  State<SidebarLineItem> createState() => _SidebarLineItemState();
}

class _SidebarLineItemState extends State<SidebarLineItem> {
  SidebarController sc = Get.find();

  bool isOpen = false;

  Color color = Colors.white.withOpacity(0.8);

  double iconSize = 20;

  double textSize = 17;

  @override
  Widget build(BuildContext context) {
    iconSize = isMobileSize() ? 25 : 20;
    return Container(
      margin: const EdgeInsets.only(left: 15, top: 15, right: 15),
      child: InkWell(
        onTap: () async {
          UserController uc = Get.find<UserController>();
          if (widget.id == "profil") {
            sc.pageChange(Profil(model: await uc.getProfile()));
          } else if (widget.id == "logout") {
            uc.logout();
          } else {
            sc.pageChange(const HomeIndex());
          }
        },
        child: Row(
          mainAxisAlignment: isMobileSize() ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(right: isMobileSize() ? 0 : 10),
              child: Icon(
                widget.icon,
                color: color,
                size: iconSize,
              ),
            ),
            if (!isMobileSize())
              Expanded(
                child: Text(
                  widget.title,
                  style: GoogleFonts.quicksand(
                    color: color,
                    fontSize: textSize,
                  ),
                ),
              ),
            if (!isMobileSize())
              Container(
                alignment: Alignment.centerRight,
                child: Icon(
                  isOpen ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
                  color: color,
                  size: iconSize + 2,
                ),
              )
          ],
        ),
      ),
    );
  }
}
