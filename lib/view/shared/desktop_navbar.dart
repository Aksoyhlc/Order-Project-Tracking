import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:orderproject/controller/state/global_controller.dart';
import 'package:orderproject/view/partial/window_icon.dart';
import 'package:window_manager/window_manager.dart';

import '../../Const/const.dart';
import '../../const/ext.dart';
import '../../generated/assets.dart';

Widget desktopNavbar() {
  GlobalController gc = Get.find();
  if (isMobile()) return const SizedBox();
  return DragToMoveArea(
    child: Obx(() {
      if (gc.loginCheck.value) {}
      return Container(
        height: 40,
        width: double.infinity,
        decoration: BoxDecoration(
          color: primaryColor,
          /*borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(5),
            topRight: Radius.circular(5),
          ),*/
        ),
        padding: EdgeInsets.only(top: 5, bottom: 5),
        child: Platform.isMacOS
            ? Container()
            : Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  //if (gc.loginCheck.value) Image.asset(Assets.imagesLogoColor, height: 30, width: 30),
                  SizedBox(width: 10),
                  if (gc.loginCheck.value)
                    Expanded(
                      child: Text(
                        gc.title.value,
                        style: GoogleFonts.quicksand(
                          color: whiteColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  InkWell(
                    onTap: () async {
                      await windowManager.minimize();
                    },
                    child: WindowIcon(Assets.imagesMinimize),
                  ),
                  InkWell(
                    onTap: () async {
                      if (await windowManager.isMaximized()) {
                        await windowManager.unmaximize();
                      } else {
                        await windowManager.maximize();
                      }
                    },
                    child: WindowIcon(Assets.imagesMaximize),
                  ),
                  InkWell(
                    onTap: () async {
                      await windowManager.close();
                    },
                    child: WindowIcon(Assets.imagesClose),
                  ),
                ],
              ),
      );
    }),
  );
}
