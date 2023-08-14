import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Const/const.dart';

InkWell languageButton({
  required String text,
  required Color color,
  required Color colorDeep,
  required Function() onTap,
  Color? textColor,
  Color? thirdColor,
}) {
  List<Color> colorList = [color, colorDeep];
  if (thirdColor != null) {
    colorList.add(thirdColor);
  }

  return InkWell(
    onTap: onTap,
    child: Container(
      width: 35,
      height: 35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        gradient: LinearGradient(
          colors: colorList,
          begin: Alignment.topCenter, //Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: colorList.length == 3 ? [0.0, 0.5, 1.0] : [0.5, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: colorList.last.withOpacity(0.9),
            blurRadius: 3,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Text(
          text,
          style: GoogleFonts.quicksand(
            color: textColor ?? whiteColor,
          ),
        ),
      ),
    ),
  );
}
