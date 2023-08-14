import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Const/const.dart';

Container tableSearchWidget(TextEditingController controller) {
  return Container(
    decoration: const BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: greyColor,
        ),
      ),
    ),
    width: 150,
    child: DefaultTextStyle(
      style: GoogleFonts.quicksand(
          //fontSize: 16,
          ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: "search".tr,
          hintStyle: GoogleFonts.quicksand(
            color: greyColor,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          prefixIcon: const Icon(Icons.search),
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
        onChanged: (value) {},
      ),
    ),
  );
}
