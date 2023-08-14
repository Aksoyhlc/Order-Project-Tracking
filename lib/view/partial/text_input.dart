import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../const/const.dart';
import '../../const/ext.dart';
import '../../controller/state/global_controller.dart';

class CustomTextInput extends StatefulWidget {
  final String name;
  final String? hintText;
  final String labelText;
  final TextInputType keyboardType;
  final String? Function(String? value)? validator;
  final double maxValue;
  final double minValue;
  final bool obscureText;

  const CustomTextInput({
    super.key,
    required this.name,
    this.hintText,
    required this.labelText,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.maxValue = 100,
    this.minValue = 0,
  })  : assert(maxValue >= minValue),
        assert(minValue >= 0),
        assert(maxValue <= 100);

  @override
  State<CustomTextInput> createState() => _CustomTextInputState();
}

class _CustomTextInputState extends State<CustomTextInput> {
  GlobalController gc = Get.find<GlobalController>();
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (gc.dataController[widget.name] == null) {
      gc.dataController[widget.name] = TextEditingController(text: gc.formData[widget.name] ?? "");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (widget.keyboardType == TextInputType.datetime) {
          FocusManager.instance.primaryFocus?.unfocus();

          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus!.unfocus();
          }
          keyboardHidden();

          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2050),
            builder: (context, child) {
              return Theme(
                data: ThemeData.light().copyWith(
                  colorScheme: const ColorScheme.light(
                    primary: primaryColor,
                    onPrimary: Colors.white,
                    surface: primaryColor,
                    onSurface: Colors.black,
                  ),
                  dialogBackgroundColor: Colors.white,
                ),
                child: child!,
              );
            },
          );

          if (pickedDate != null) {
            gc.formData[widget.name] = DateFormat().addPattern("dd.MM.yyyy").format(pickedDate).toString();
            gc.dataController[widget.name]!.text = gc.formData[widget.name]!;

            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
              FocusManager.instance.primaryFocus!.unfocus();
            }
          }
        } else {
          focusNode.requestFocus();
        }
      },
      child: Container(
        constraints: BoxConstraints(maxWidth: isMobileSize() ? double.infinity : 0.25.sw),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: greyColor,
                  width: 2,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Container(
                margin: const EdgeInsets.only(bottom: 5),
                child: AbsorbPointer(
                  absorbing: widget.keyboardType == TextInputType.datetime,
                  child: TextFormField(
                    obscureText: widget.obscureText,
                    focusNode: focusNode,
                    keyboardType: widget.keyboardType,
                    inputFormatters: [
                      if (widget.keyboardType == TextInputType.number) FilteringTextInputFormatter.digitsOnly,
                    ],
                    controller: gc.dataController[widget.name], //TextEditingController(text: gc.formData[widget.name]),
                    decoration: InputDecoration(
                      hintText: widget.hintText ?? widget.labelText,
                      border: InputBorder.none,
                      isDense: true,
                      hintStyle: GoogleFonts.quicksand(
                        color: Colors.grey.withOpacity(0.7),
                        fontSize: 14,
                      ),
                      //hintText: widget.hintText,
                      isCollapsed: true,
                    ),
                    cursorColor: primaryColor,
                    style: GoogleFonts.quicksand(
                      color: greyColor,
                      fontSize: 16,
                    ),
                    validator: widget.validator,
                    onChanged: (value) {
                      gc.formData[widget.name] = value;
                    },
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.white,
              transform: Matrix4.translationValues(0, -9, 0),
              margin: const EdgeInsets.only(left: 20),
              child: Text(
                widget.labelText,
                style: GoogleFonts.quicksand(
                  color: greyColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
