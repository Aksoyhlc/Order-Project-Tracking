import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Const/const.dart';

class RowCheckBox extends StatefulWidget {
  final String text;
  final bool value;
  final Function(bool check) onChanged;

  const RowCheckBox({super.key, required this.text, this.value = false, required this.onChanged});

  @override
  State<RowCheckBox> createState() => _RowCheckBoxState();
}

class _RowCheckBoxState extends State<RowCheckBox> {
  bool check = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    check = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Checkbox(
          value: check,
          activeColor: primaryColor,
          onChanged: (value) {
            setState(() {
              check = value!;
            });
          },
        ),
        InkWell(
          onTap: () {
            setState(() {
              check = !check;
            });
            widget.onChanged(check);
          },
          child: Text(
            widget.text,
            style: GoogleFonts.quicksand(
              color: greyColor,
            ),
          ),
        ),
      ],
    );
  }
}
