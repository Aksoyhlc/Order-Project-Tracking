import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Const/const.dart';

Container seperator(String title) {
  return Container(
    margin: const EdgeInsets.only(top: 20),
    child: Stack(
      children: [
        Container(
          width: double.infinity,
          height: 2,
          color: greyColor.withOpacity(0.2),
          margin: const EdgeInsets.only(top: 8),
        ),
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: backColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              title,
              style: GoogleFonts.quicksand(
                color: greyColor,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
