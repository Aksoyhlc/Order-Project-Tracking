import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Const/const.dart';
import '../../const/ext.dart';

class CustomDropDownMenu extends StatefulWidget {
  //final List<String> items;
  final Map<String, String> items;
  final String selectKey;
  final String? label;
  final String labelText;
  final double maxWidth;
  final BoxDecoration? boxDecoration;
  final EdgeInsets topPadding;
  final Function(String key, String value) onSelect;
  final Function()? onInit;

  const CustomDropDownMenu({
    super.key,
    required this.items,
    this.label,
    this.labelText = "",
    this.boxDecoration,
    this.topPadding = const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    required this.selectKey,
    required this.onSelect,
    this.onInit,
    this.maxWidth = 150,
  });

  @override
  State<CustomDropDownMenu> createState() => _CustomDropDownMenuState();
}

class _CustomDropDownMenuState extends State<CustomDropDownMenu> {
  bool openMenu = false;
  late BoxDecoration boxDecoration;
  String defaultText = "choose".tr;

  ScrollController scrollController = ScrollController();
  GlobalKey key = GlobalKey();

  OverlayState? overlayState;
  OverlayEntry? overlayEntry;

  closeOverlay() {
    overlayEntry?.remove();
    overlayEntry = null;
    overlayState = null;
    openMenu = false;

    if (mounted) {
      setState(() {});
    }
  }

  buildOverlay(BuildContext context) {
    RenderBox renderBox = key.currentContext!.findRenderObject() as RenderBox;
    Offset startOffset = renderBox.localToGlobal(Offset.zero);
    double y = startOffset.dy + renderBox.size.height;
    Offset endOffset = renderBox.localToGlobal(Offset(renderBox.size.width, y));

    overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            GestureDetector(
              onTap: () {
                closeOverlay();
              },
              child: Container(
                color: Colors.transparent,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            Positioned(
              top: y,
              left: startOffset.dx,
              right: MediaQuery.sizeOf(context).width - endOffset.dx,
              child: Material(
                color: Colors.transparent,
                child: Visibility(
                  visible: openMenu,
                  child: FadeInDown(
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      width: double.infinity,
                      constraints: BoxConstraints(maxWidth: isMobileSize() ? double.infinity : widget.maxWidth, maxHeight: 200),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            blurRadius: 1,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      margin: const EdgeInsets.only(top: 5, right: 5, left: 5, bottom: 5),
                      child: Scrollbar(
                        thumbVisibility: true,
                        controller: scrollController,
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: widget.items.length,
                          shrinkWrap: true,

                          //physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                widget.onSelect(widget.items.keys.toList()[index], widget.items.values.toList()[index]);
                                defaultText = widget.items.values.toList()[index];
                                closeOverlay();
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                child: Text(
                                  widget.items.values.toList()[index],
                                  style: GoogleFonts.quicksand(color: Colors.grey),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
    overlayState!.insert(overlayEntry!);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.label == null) {
      defaultText = widget.items[widget.selectKey] ?? "choose".tr;
    } else {
      defaultText = widget.label!;
    }
    if (widget.onInit != null) {
      widget.onInit!();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.boxDecoration == null) {
      boxDecoration = BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      );
    } else {
      boxDecoration = widget.boxDecoration!;
    }
    return Stack(
      children: [
        Column(
          children: [
            InkWell(
              onTap: () {
                if (openMenu) {
                  overlayEntry?.remove();
                  overlayEntry = null;
                  overlayState = null;
                  openMenu = false;
                } else {
                  buildOverlay(context);
                  openMenu = true;
                }

                setState(() {});
              },
              child: Container(
                key: key,
                width: double.infinity,
                constraints: BoxConstraints(maxWidth: isMobileSize() ? double.infinity : widget.maxWidth),
                decoration: boxDecoration,
                padding: widget.topPadding,
                child: Row(
                  children: [
                    Expanded(
                      child: AutoSizeText(
                        defaultText,
                        style: GoogleFonts.quicksand(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    AnimatedCrossFade(
                      firstChild: const Icon(
                        Icons.keyboard_arrow_down,
                        color: primaryColor,
                        size: 20,
                      ),
                      secondChild: const Icon(
                        Icons.keyboard_arrow_up,
                        color: primaryColor,
                        size: 20,
                      ),
                      crossFadeState: !openMenu ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                      duration: const Duration(milliseconds: 300),
                    ),
                  ],
                ),
              ),
            ),
          ],
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
        ),
      ],
    );
  }
}
