import 'package:flutter/material.dart';
import 'package:get/get.dart';

const String fileUploadFolderName = "/OrderProjectFiles/";
const String assetPath = "assets/";
const String imagePath = "${assetPath}images/";
const String iconPath = "${assetPath}icons/";
const Color backColor = Color(0xFFf8f9fc);
const Color primaryColor = Color(0xFF4e73df);
const Color primaryColorDeep = Color(0xFF224abe);
const Color greyColor = Color(0xFF858796);
const Color greenColor = Color(0xFF1cc88a);
const Color redColor = Color(0xFFe74a3b);
const Color redColorDeep = Color(0xffcc3022);
const Color whiteColor = Color(0xFFf8f9fc);
const Color darkColor = Color(0xFF5a5c69);
const Color infoColor = Color(0xFF36b9cc);
const Color warningColor = Color(0xffccb836);
/*
const Map<String, String> status = {
  "0": "Pending",
  "1": "Continues",
  "2": "Denied",
  "3": "Cancelled",
  "4": "Completed",
};*/

enum Status { Pending, Continues, Cancelled, Completed }

/*const Map<String, String> urgency = {
  "0": "Low",
  "1": "Medium",
  "2": "High",
  "3": "Urgent",
};*/

enum Urgency { Low, Medium, High, Urgent }

const List<String> imageExtensions = [
  'jpg',
  'png',
  'jpeg',
  'gif',
  'bmp',
  'webp',
  'svg',
];

const List<String> allowedExtensions = [
  'pdf',
  'doc',
  'docx',
  'xls',
  'xlsx',
  'csv',
  'txt',
  'jpg',
  'png',
  'jpeg',
  'gif',
  'mp4',
  'avi',
  'mkv',
  'mp3',
  'wav',
  'aac',
  'ogg',
  'zip',
  'rar',
  'tar',
  'gz',
  '7z',
];

List<String> MonthList = [
  "Jan".tr,
  "Feb".tr,
  "Mar".tr,
  "Apr".tr,
  "May".tr,
  "Jun".tr,
  "Jul".tr,
  "Aug".tr,
  "Sep".tr,
  "Oct".tr,
  "Nov".tr,
  "Dec".tr,
];
