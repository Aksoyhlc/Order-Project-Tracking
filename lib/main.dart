import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:window_manager/window_manager.dart';

import 'const/const.dart';
import 'const/ext.dart';
import 'const/language/language.dart';
import 'controller/db/db_controller.dart';
import 'controller/state/global_controller.dart';
import 'view/auth/login.dart';
import 'view/index.dart';
import 'view/setup/setup.dart';
import 'view/shared/desktop_navbar.dart';

String? lang;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!isMobile()) {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = const WindowOptions(
      fullScreen: false,
      minimumSize: Size(500, 600),
      title: 'Order - Project Tracking',
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      if (Platform.isMacOS) {
        await windowManager.setBadgeLabel('Order - Project Tracking');
      }
      await windowManager.setTitleBarStyle(TitleBarStyle.hidden);
      /*await windowManager.setMaximizable(true);
      await windowManager.maximize();*/
      await windowManager.show();
      await windowManager.focus();
    });
  }

  if (isMobile()) {
    PermissionStatus status = await Permission.notification.request();

    if (status.isGranted) {
      await OneSignal.shared.setAppId("7c14efd4-055b-42ef-bcd0-4fbda4f5b9e7");
      if (Platform.isIOS) {
        OneSignal.shared.setPermissionObserver((changes) async {
          if (!changes.from.hasPrompted) {
            await OneSignal.shared.addTrigger("prompt_ios", "true");
          }
        });
      }
    }
  }

  DB db = DB();
  lang = await db.getSettings("lang");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) {
        return GetMaterialApp(
          translations: Lang(),
          locale: lang == null ? Get.deviceLocale : Lang.getLang(lang!),
          fallbackLocale: Lang.def,
          scrollBehavior: const MaterialScrollBehavior().copyWith(
            dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch, PointerDeviceKind.stylus, PointerDeviceKind.unknown},
          ),
          title: 'Order - Project Tracking',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
            useMaterial3: false,
          ),
          home: child,
          onInit: () {
            controllerInjection();
          },
        );
      },
      child: const MainHomePage(),
    );
  }
}

class MainHomePage extends StatefulWidget {
  const MainHomePage({super.key});

  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  late GlobalController gc;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryColor,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              desktopNavbar(),
              Expanded(
                child: FutureBuilder(
                  future: process(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data == true) {
                        return gc.loginCheck.value ? const HomePage() : const LoginPage();
                      } else {
                        return SetupPage();
                      }
                    } else {
                      return loading();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> process() async {
    controllerInjection();
    gc = Get.find<GlobalController>();
    gc.documentDirectory.value = (await getApplicationDocumentsDirectory()).path.replaceAll("\\", "/");

    if (!File(gc.documentDirectory.value + "/log.txt").existsSync()) {}

    DB db = DB();
    String? setup = await db.getSettings("setup");

    return setup != null;
  }
}
