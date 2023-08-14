import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Const/const.dart';

class PrimaryButton extends StatefulWidget {
  final String text;
  final Function()? onPressed;
  const PrimaryButton({super.key, required this.text, this.onPressed});

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.5),
              blurRadius: 5,
              offset: Offset(0, 5),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Center(
          child: Text(
            "save".tr,
            style: GoogleFonts.quicksand(
              color: whiteColor,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
