import 'package:animate_do/animate_do.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:orderproject/controller/db/db_controller.dart';
import 'package:orderproject/controller/state/global_controller.dart';
import 'package:orderproject/main.dart';
import 'package:orderproject/model/users.dart';
import 'package:orderproject/view/partial/primaryButton.dart';
import 'package:orderproject/view/partial/row_checkbox.dart';
import 'package:orderproject/view/partial/text_input.dart';
import 'package:window_manager/window_manager.dart';

import '../../const/const.dart';
import '../../const/ext.dart';
import '../../const/language/language.dart';
import '../../controller/user_controller.dart';
import 'widget/language_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool rememberMe = false;
  DB db = DB();
  GlobalController gc = Get.find();

  AsyncMemoizer _memoizer = AsyncMemoizer();

  Future fetchData() async {
    return _memoizer.runOnce(() async {
      await getData();
      return true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gc.formData.clear();
    gc.dataController.values.map((e) => e.dispose());
    gc.dataController.clear();
  }

  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor,
            primaryColorDeep,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: RawKeyboardListener(
          onKey: (event) {
            if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
              login();
            }
          },
          focusNode: focusNode,
          child: Center(
            child: FutureBuilder(
              future: fetchData(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    // height: 500,
                    constraints: BoxConstraints(maxWidth: 500, maxHeight: 550),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: whiteColor.withOpacity(0.3),
                          blurRadius: 10,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //Expanded(child: Container()),
                          FadeInDown(
                            duration: Duration(milliseconds: 800),
                            child: Text(
                              "login".tr,
                              style: GoogleFonts.yellowtail(
                                fontSize: 50,
                                fontWeight: FontWeight.w500,
                                color: primaryColor,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          ZoomIn(
                            duration: Duration(milliseconds: 800),
                            child: CustomTextInput(
                              name: "login_email",
                              labelText: "email".tr,
                              hintText: "email".tr,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ZoomIn(
                            duration: Duration(milliseconds: 800),
                            child: CustomTextInput(
                              name: "login_password",
                              labelText: "password".tr,
                              hintText: "password".tr,
                              obscureText: true,
                            ),
                          ),
                          SizedBox(height: 20),
                          ZoomIn(
                            duration: Duration(milliseconds: 800),
                            child: RowCheckBox(
                              onChanged: (check) {
                                setState(() {
                                  rememberMe = !rememberMe;
                                });
                              },
                              text: "remember_me".tr,
                              value: rememberMe,
                            ),
                          ),
                          SizedBox(height: 20),
                          FadeInUp(
                            duration: Duration(milliseconds: 800),
                            child: PrimaryButton(
                              text: "login".tr,
                              onPressed: () {
                                login();
                              },
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              languageButton(
                                text: "TR",
                                color: redColor,
                                colorDeep: redColorDeep,
                                onTap: () {
                                  db.setSettings("lang", "tr");
                                  Get.updateLocale(Lang.tr);
                                },
                              ),
                              SizedBox(width: 5),
                              languageButton(
                                text: "EN",
                                color: primaryColor,
                                colorDeep: primaryColorDeep,
                                onTap: () {
                                  db.setSettings("lang", "en");

                                  Get.updateLocale(Lang.en);
                                },
                              ),
                              SizedBox(width: 5),
                              languageButton(
                                text: "DE",
                                color: darkColor,
                                colorDeep: redColor,
                                thirdColor: warningColor,
                                onTap: () {
                                  db.setSettings("lang", "de");

                                  Get.updateLocale(Lang.de);
                                },
                              ),
                              SizedBox(width: 5),
                              languageButton(
                                text: "IN",
                                color: warningColor,
                                colorDeep: whiteColor,
                                thirdColor: greenColor,
                                textColor: primaryColor,
                                onTap: () {
                                  db.setSettings("lang", "hi");

                                  Get.updateLocale(Lang.hi);
                                },
                              ),
                              SizedBox(width: 5),
                              languageButton(
                                text: "CN",
                                color: redColor,
                                colorDeep: warningColor,
                                onTap: () {
                                  db.setSettings("lang", "zh");

                                  Get.updateLocale(Lang.zh);
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          //Expanded(child: Container()),
                          poweredBy(),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Container(
                    width: 50,
                    height: 50,
                    child: const CircularProgressIndicator(
                      color: whiteColor,
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> getData() async {
    String? remember = await db.getSettings("remember");

    if (remember != null && remember.isNotEmpty) {
      gc.formData['login_email'] = remember;
      rememberMe = true;
    }

    return true;
  }

  login() async {
    UserController uc = UserController();
    GlobalController gc = Get.find();
    UserModel? user = await uc.login(gc.formData['login_email'] ?? "", gc.formData['login_password'] ?? "");

    if (user == null) {
      gc.dataController['login_password']!.text = "";
      gc.formData['login_password'] = "";
      showSnackBar(context, "login_error".tr, "login_error_msg".tr, 0);
      gc.loginCheck.value = false;
    } else {
      showSnackBar(context, "success".tr, "login_ok".tr, 1);

      if (rememberMe) {
        await db.setSettings("remember", gc.formData['login_email']);
      } else {
        await db.deleteSettings("remember");
      }

      await Future.delayed(Duration(seconds: 1));
      if (!isMobile()) {
        await windowManager.setMaximizable(true);
        await windowManager.maximize();
      }

      gc.loginCheck.value = true;
      Get.offAll(() => MainHomePage());
    }
  }
}
