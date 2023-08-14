import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:orderproject/const/const.dart';
import 'package:orderproject/controller/state/global_controller.dart';
import 'package:orderproject/controller/state/sidebar_controller.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../controller/customer_controller.dart';
import '../controller/user_controller.dart';

Color renk(String renk) {
  if (renk.contains("#")) {
    renk = renk.replaceAll("#", "");
  }
  return Color(int.parse("0xFF$renk"));
}

void controllerInjection() {
  if (!Get.isRegistered<SidebarController>()) {
    Get.put(SidebarController());
  }
  if (!Get.isRegistered<GlobalController>()) {
    Get.put(GlobalController());
  }
  if (!Get.isRegistered<CustomerController>()) {
    Get.put(CustomerController());
  }
  if (!Get.isRegistered<UserController>()) {
    Get.put(UserController());
  }
}

Center loading() => const Center(child: CircularProgressIndicator());

hr({double yukseklik = 1, String tur = "normal", double bosluk = 10}) {
  if (tur == "normal") {
    return Container(
      margin: EdgeInsets.symmetric(vertical: bosluk),
      height: yukseklik,
      color: Colors.grey[300],
    );
  } else {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      height: yukseklik,
      color: Colors.grey[100],
    );
  }
}

String textRepeat(String text, int count) {
  String newText = "";
  for (var i = 0; i < count; i++) {
    newText += text;
  }
  return newText;
}

void showSnackBar(BuildContext context, String title, String desc, int type) {
  //Get.closeAllSnackbars();

  Get.snackbar(
    title,
    desc,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: type == 1 ? greenColor : redColor,
    colorText: Colors.white,
    maxWidth: 500,
    margin: const EdgeInsets.only(bottom: 20),
  );
}

void keyboardHidden() {
  if (Platform.isAndroid || Platform.isAndroid) {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    FocusManager.instance.primaryFocus?.unfocus();
  }
}

bool isImage(String path) {
  List<String> parse = path.split(".");
  if (parse.isEmpty) return false;
  String ext = parse.last;
  return imageExtensions.contains(ext);
}

bool isMobileSize() {
  if (GetPlatform.isAndroid || GetPlatform.isIOS) {
    return true;
  } else {
    if (Get.width < 900) {
      return true;
    } else {
      return false;
    }
  }
}

bool isMobile({bool mac = false}) {
  if (GetPlatform.isMacOS && mac) {
    return true;
  }
  return GetPlatform.isAndroid || GetPlatform.isIOS;
}

bool isNumeric(dynamic s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s.toString()) != null;
}

Widget poweredBy() {
  return ZoomIn(
    delay: const Duration(milliseconds: 400),
    child: RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "Powered By ",
            style: GoogleFonts.quicksand(
              color: greyColor,
            ),
          ),
          TextSpan(
            text: "Aksoyhlc",
            style: GoogleFonts.quicksand(
              color: primaryColor,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                if (await canLaunchUrlString("https://github.com/Aksoyhlc")) {
                  await launchUrlString(
                    "https://github.com/Aksoyhlc",
                    mode: LaunchMode.externalApplication,
                    webOnlyWindowName: "https://github.com/Aksoyhlc",
                  );
                }
              },
          ),
        ],
      ),
    ),
  );
}

String fileExtension(String path) {
  List<String> parse = path.split(".");
  if (parse.isEmpty) return "";
  String ext = parse.last;
  return ext;
}

String fileName(String path) {
  String fileName = "";
  if (path.contains("\\")) {
    fileName = path.split("\\").last;
  } else if (path.contains("/")) {
    fileName = path.split("/").last;
  } else {
    fileName = path;
  }
  return fileName;
}

String? fileUpload(String? path) {
  if (path == null || fileName(path) == "") return null;
  GlobalController gc = Get.find();
  String docDirPath = gc.documentDirectory.value + fileUploadFolderName;
  String newPath = docDirPath;

  if (!Directory(docDirPath).existsSync()) {
    Directory(docDirPath).createSync(recursive: true);
  }
  newPath += fileName(path);
  newPath = newPath.replaceAll("\\", "/");

  File(path).copySync(newPath);

  return fileName(newPath);
}

String getUploadFilePath(String name) {
  GlobalController gc = Get.find();
  return gc.documentDirectory.value + fileUploadFolderName + name;
}

void logWrite(String text) {
  String line = textRepeat("-", 50);
  GlobalController gc = Get.find();
  String docDirPath = gc.documentDirectory.value + "/log.txt";
  File file = File(docDirPath);
  file.writeAsStringSync(text + "\n", mode: FileMode.append);
}
