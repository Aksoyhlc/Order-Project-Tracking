import 'package:flutter/material.dart';

import '../../Const/const.dart';

class WindowIcon extends StatefulWidget {
  final String path;

  const WindowIcon(this.path, {super.key});

  @override
  State<WindowIcon> createState() => _WindowIconState();
}

class _WindowIconState extends State<WindowIcon> {
  bool onHover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (value) {
        setState(() {
          onHover = true;
        });
      },
      onExit: (value) {
        setState(() {
          onHover = false;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: onHover ? whiteColor.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(5),
        ),
        margin: const EdgeInsets.only(right: 5),
        child: Image.asset(
          widget.path,
          height: 25,
          width: 25,
          color: whiteColor,
        ),
      ),
    );
  }
}
