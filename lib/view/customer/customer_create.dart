import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:orderproject/const/const.dart';
import 'package:orderproject/const/ext.dart';
import 'package:orderproject/controller/customer_controller.dart';
import 'package:orderproject/controller/state/global_controller.dart';
import 'package:orderproject/model/customer.dart';
import 'package:orderproject/view/partial/card.dart';

import '../partial/text_input.dart';
import 'customers.dart';

class CustomerCreate extends StatefulWidget {
  final CustomerModel? customer;

  const CustomerCreate({Key? key, this.customer}) : super(key: key);

  @override
  State<CustomerCreate> createState() => _CustomerCreateState();
}

class _CustomerCreateState extends State<CustomerCreate> {
  GlobalKey<FormState> formkey = GlobalKey();
  GlobalController gc = Get.find<GlobalController>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gc.formData.clear();
    gc.dataController.clear();
    if (widget.customer != null) {
      gc.formData.addAll({
        'customer_name': widget.customer!.name,
        'customer_mail': widget.customer!.mail,
        'customer_phone': widget.customer!.phone,
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    gc.formData.clear();
    gc.dataController.clear();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      title: "customer_create".tr,
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
                name: 'customer_name',
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
                name: 'customer_mail',
                hintText: "E-mail",
                labelText: "E-mail",
              ),
              const SizedBox(height: 20),
              CustomTextInput(
                name: 'customer_phone',
                labelText: "phone".tr,
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () async {
                  if (formkey.currentState!.validate()) {
                    formkey.currentState!.save();
                    bool result = false;
                    String action = "";
                    CustomerController cc = Get.find<CustomerController>();
                    if (widget.customer != null) {
                      gc.formData.addAll({
                        'customer_id': widget.customer!.cusId,
                      });
                      result = await cc.updateCustomer();
                      action = "updated".tr;
                    } else {
                      result = await cc.addCustomer();
                      action = "created".tr;
                    }

                    if (result) {
                      showSnackBar(
                          context,
                          "success".tr,
                          "customer_action_success".trParams(
                            {"action": action},
                          ),
                          1);
                      gc.formData.clear();
                      gc.sc.page.value = const Customers();
                    } else {
                      showSnackBar(
                          context,
                          "error".tr,
                          "customer_action_error".trParams(
                            {"action": action},
                          ),
                          0);
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
                      Text("save".tr),
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
