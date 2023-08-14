import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Const/const.dart';
import '../../../Const/ext.dart';

class StatCard extends StatelessWidget {
  final Color color;
  final String title;
  final String value;
  final IconData icon;

  const StatCard({
    super.key,
    required this.color,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ZoomIn(
      child: Container(
        constraints: BoxConstraints(maxWidth: Get.width < 600 || isMobile() ? double.infinity : 275),
        margin: EdgeInsets.only(top: 15, right: isMobileSize() ? 0 : 10, left: isMobileSize() ? 0 : 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: greyColor.withOpacity(0.2),
              blurRadius: 3,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            constraints: const BoxConstraints(minHeight: 100),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                left: BorderSide(
                  color: color,
                  width: 5,
                ),
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      Text(
                        value,
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: darkColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  icon,
                  color: greyColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
