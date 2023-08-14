import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Const/const.dart';

InkWell iconTextButton({
  required String text,
  required IconData icon,
  required Color color,
  required Function() onTap,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: color,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.5),
            spreadRadius: 0,
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: whiteColor,
            size: 18,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: GoogleFonts.quicksand(
              color: whiteColor,
            ),
          ),
        ],
      ),
    ),
  );
}
