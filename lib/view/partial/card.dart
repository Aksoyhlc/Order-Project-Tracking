import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:orderproject/controller/state/sidebar_controller.dart';

import '../../const/const.dart';
import '../../const/ext.dart';

class CustomCard extends StatefulWidget {
  final String title;
  final Widget child;
  final Widget headRightWidget;

  const CustomCard({
    super.key,
    required this.title,
    required this.child,
    this.headRightWidget = const SizedBox(),
  });

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  SidebarController sc = Get.find<SidebarController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: isMobileSize() ? double.infinity : 0.90.sw),
      padding: const EdgeInsets.all(15),
      margin: EdgeInsets.symmetric(vertical: 15, horizontal: isMobileSize() ? 0 : 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: AutoSizeText(
                  widget.title,
                  maxLines: 1,
                  style: GoogleFonts.quicksand(
                    color: primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                  child: Container(
                      alignment: Alignment.centerRight, child: Obx(() => sc.selectedMenu.value == "" ? widget.headRightWidget : Container()))),
            ],
          ),
          hr(),
          Expanded(child: widget.child)
        ],
      ),
    );
  }
}
