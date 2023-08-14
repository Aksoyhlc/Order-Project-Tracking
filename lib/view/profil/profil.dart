import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:orderproject/controller/user_controller.dart';
import 'package:orderproject/model/users.dart';

import '../../Const/const.dart';
import '../../const/ext.dart';
import '../../controller/state/global_controller.dart';
import '../partial/card.dart';
import '../partial/text_input.dart';

class Profil extends StatefulWidget {
  final UserModel model;
  const Profil({super.key, required this.model});

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  GlobalKey<FormState> formkey = GlobalKey();
  GlobalController gc = Get.find<GlobalController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gc.formData['name'] = widget.model.name;
    gc.formData['email'] = widget.model.email;
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      title: "profil".tr,
      child: DefaultTextStyle(
        style: GoogleFonts.quicksand(
          fontSize: 16,
        ),
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: formkey,
          child: Column(
            children: [
              CustomTextInput(
                name: 'name',
                hintText: "name".tr,
                labelText: "name".tr,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "not_empty".tr;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CustomTextInput(
                name: 'email',
                hintText: "E-mail",
                labelText: "E-mail",
                validator: (value) {
                  if (value!.isEmpty) {
                    return "not_empty".tr;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CustomTextInput(
                name: 'password',
                hintText: "password".tr,
                labelText: "password".tr,
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () async {
                  if (formkey.currentState!.validate()) {
                    formkey.currentState!.save();

                    UserController uc = UserController();

                    Map<String, dynamic> formData = {
                      "id": widget.model.id,
                      "name": gc.formData['name'],
                      "email": gc.formData['email'],
                      "lastupdate": DateTime.now().toString().split(".").first,
                      "source": 3,
                    };

                    if (gc.formData['password'] != null) {
                      formData['password'] = gc.formData['password'];
                    }

                    bool result = await uc.updateProfile(formData);

                    if (result) {
                      showSnackBar(context, "success".tr, "update_profile_success".tr, 1);
                      gc.formData['password'] = "";
                      gc.dataController['password']?.text = "";
                      setState(() {});
                    } else {
                      showSnackBar(context, "error".tr, "update_profile_error".tr, 0);
                    }
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 0.25.sw,
                  height: 0.05.sh,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.save_outlined, color: Colors.white),
                      SizedBox(width: 5),
                      Text("update".tr),
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
