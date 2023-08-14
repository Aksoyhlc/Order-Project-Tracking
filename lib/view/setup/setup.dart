import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:orderproject/controller/db/db_controller.dart';
import 'package:orderproject/controller/state/global_controller.dart';
import 'package:orderproject/controller/user_controller.dart';
import 'package:orderproject/main.dart';
import 'package:orderproject/view/partial/primaryButton.dart';
import 'package:orderproject/view/partial/text_input.dart';

import '../../Const/const.dart';
import '../../const/ext.dart';

class SetupPage extends StatefulWidget {
  const SetupPage({super.key});

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  GlobalController gc = Get.find<GlobalController>();
  bool loginReq = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gc.formData["appname"] = "";
    gc.formData["first_mail"] = "aksoyhlc@gmail.com";
    gc.formData["first_password"] = "123";
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                constraints: BoxConstraints(maxWidth: 500),
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
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      FadeInDown(
                        duration: Duration(milliseconds: 800),
                        child: Text(
                          "setup".tr,
                          style: GoogleFonts.yellowtail(
                            fontSize: 50,
                            fontWeight: FontWeight.w500,
                            color: primaryColor,
                          ),
                        ),
                      ),
                      FadeInDown(
                        delay: Duration(milliseconds: 400),
                        duration: Duration(milliseconds: 800),
                        child: Text(
                          "setup_message".tr,
                          style: GoogleFonts.quicksand(
                            color: primaryColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 30),
                      CustomTextInput(
                        name: "first_mail",
                        labelText: "first_mail".tr,
                        validator: (value) {
                          if (!GetUtils.isEmail(value!)) {
                            return "first_mail_error".tr;
                          }
                          return null;
                        },
                      ),
                      CustomTextInput(
                        name: "first_password",
                        labelText: "first_password".tr,
                        validator: (value) {
                          if (value!.length < 3) {
                            return "first_password_error".tr;
                          }
                          return null;
                        },
                      ),
                      /* Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: loginReq,
                            activeColor: primaryColor,
                            onChanged: (value) {
                              setState(() {
                                loginReq = value!;
                              });
                            },
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                loginReq = !loginReq;
                              });
                            },
                            child: Text(
                              "Require login",
                              style: GoogleFonts.quicksand(
                                color: greyColor,
                              ),
                            ),
                          ),
                        ],
                      ),*/
                      SizedBox(height: 20),
                      FadeInUp(
                        duration: Duration(milliseconds: 800),
                        child: PrimaryButton(
                          text: "save".tr,
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              UserController uc = UserController();
                              bool status = await uc.updateProfile({
                                "email": gc.formData["first_mail"],
                                "password": gc.formData["first_password"],
                                "id": "1",
                              });

                              DB db = DB();
                              await db.setSettings("setup", "true");

                              if (status) {
                                showSnackBar(context, "success".tr, "setup_ok".tr, 1);
                                Get.offAll(() => const MainHomePage());
                              } else {
                                showSnackBar(context, "error".tr, "setup_error".tr, 0);
                                await Future.delayed(Duration(seconds: 2));
                                showSnackBar(context, "error".tr, "", 0);
                              }
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      poweredBy(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
