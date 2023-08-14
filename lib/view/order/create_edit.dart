import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:orderproject/controller/customer_controller.dart';
import 'package:orderproject/controller/order_controller.dart';
import 'package:orderproject/model/customer.dart';
import 'package:orderproject/model/order.dart';
import 'package:orderproject/view/order/orders.dart';

import '../../const/const.dart';
import '../../const/ext.dart';
import '../../controller/state/global_controller.dart';
import '../partial/card.dart';
import '../partial/dropdown.dart';
import '../partial/text_input.dart';

class OrderCreateEdit extends StatefulWidget {
  final OrderModel? order;

  const OrderCreateEdit({super.key, this.order});

  @override
  State<OrderCreateEdit> createState() => _OrderCreateEditState();
}

class _OrderCreateEditState extends State<OrderCreateEdit> {
  GlobalKey<FormState> formkey = GlobalKey();
  GlobalController gc = Get.find<GlobalController>();
  CustomerController cc = CustomerController();
  OrderController oc = OrderController();
  File? selectedFile;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gc.formData.clear();
    gc.dataController.clear();
    if (widget.order != null) {
      selectedFile = widget.order?.filePath == null ? null : File(gc.documentDirectory.value + fileUploadFolderName + (widget.order?.filePath ?? ""));
      gc.formData.addAll({
        "id": widget.order?.id.toString(),
        "title": widget.order?.title,
        "price": widget.order?.price,
        "percentage": widget.order?.percentage.toString(),
        "start_date": widget.order?.startDate,
        "delivery_date": widget.order?.deliveryDate,
        "status": widget.order?.status,
        "urgency": widget.order?.urgency,
        "details": widget.order?.details,
        "customer": widget.order?.customer.toString(),
        "file_path": widget.order?.filePath,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      title: "create_order".tr,
      child: DefaultTextStyle(
        style: GoogleFonts.quicksand(
          fontSize: 16,
        ),
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: formkey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Wrap(
                  children: [
                    CustomTextInput(
                      name: "title",
                      labelText: "title".tr,
                      //maxValue: 10,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "not_empty".tr;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(width: 20),
                    CustomTextInput(
                      name: "percentage",
                      labelText: "percent".tr,
                      hintText: "percent".tr,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "not_empty".tr;
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                Wrap(
                  children: [
                    CustomTextInput(
                      name: "start_date",
                      labelText: "start_date".tr,
                      hintText: "start_date".tr,
                      keyboardType: TextInputType.datetime,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "not_empty".tr;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(width: 20),
                    CustomTextInput(
                      name: "delivery_date",
                      labelText: "end_date".tr,
                      keyboardType: TextInputType.datetime,
                    ),
                  ],
                ),
                Wrap(
                  /*mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,*/
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: CustomDropDownMenu(
                        maxWidth: 0.25.sw,
                        items: {for (var e in Status.values) e.index.toString(): e.toString().split(".").last.toLowerCase().tr},
                        labelText: "status".tr,
                        selectKey: (widget.order?.status ?? 0).toString(),
                        onSelect: (key, value) {
                          gc.formData["status"] = key;
                        },
                        onInit: () {
                          gc.formData["status"] = (widget.order?.status ?? 0).toString();
                        },
                        topPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                        boxDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: greyColor,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: CustomDropDownMenu(
                        maxWidth: 0.25.sw,
                        items: {for (var e in Urgency.values) e.index.toString(): e.toString().split(".").last.toLowerCase().tr},
                        labelText: "urgency".tr,
                        selectKey: (widget.order?.urgency ?? 0).toString(),
                        onSelect: (key, value) {
                          gc.formData["urgency"] = key;
                        },
                        onInit: () {
                          gc.formData["urgency"] = (widget.order?.urgency ?? 0).toString();
                        },
                        topPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                        boxDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: greyColor,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Wrap(
                  children: [
                    FutureBuilder(
                      future: cc.customerList(),
                      builder: (context, AsyncSnapshot<List<CustomerModel>> snapshot) {
                        if (snapshot.hasData) {
                          Map<String, String> items = {};
                          for (var element in snapshot.data!) {
                            items[element.cusId.toString()] = element.name ?? "";
                          }

                          return Container(
                            padding: const EdgeInsets.all(10),
                            child: CustomDropDownMenu(
                              maxWidth: 0.25.sw,
                              items: items,
                              labelText: "customer".tr,
                              selectKey: widget.order?.customer ?? "0",
                              onSelect: (index, value) {},
                              topPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                              boxDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: greyColor,
                                  width: 2,
                                ),
                              ),
                            ),
                          );
                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
                    ),
                    const SizedBox(width: 20),
                    CustomTextInput(
                      name: "price",
                      labelText: "price".tr,
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
                SizedBox(
                  width: isMobileSize() ? double.infinity : 0.33.sw,
                  child: Column(
                    children: [
                      GetBuilder<GlobalController>(
                        init: gc,
                        id: "order_file_list",
                        builder: (logic) {
                          String file = "";
                          if (selectedFile != null) {
                            file = fileName(selectedFile!.path);
                          }
                          return selectedFile == null
                              ? Container()
                              : Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      width: 1,
                                      color: greyColor,
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      if (isImage(selectedFile!.path))
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 1,
                                              color: greyColor,
                                            ),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          padding: const EdgeInsets.all(5),
                                          child: InkWell(
                                            onTap: () async {
                                              Get.defaultDialog(
                                                title: "image".tr,
                                                content: Expanded(
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                      children: [
                                                        Image.file(selectedFile!),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Image.file(
                                              selectedFile!,
                                              width: 50,
                                              height: 50,
                                            ),
                                          ),
                                        ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          file,
                                          style: GoogleFonts.quicksand(
                                            color: greyColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      InkWell(
                                        onTap: () {
                                          selectedFile = null;
                                          gc.update(["order_file_list"]);
                                        },
                                        child: Icon(
                                          Icons.delete_forever_outlined,
                                          color: redColor.withOpacity(0.7),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                        },
                      ),
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: () async {
                          FilePickerResult? result = await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: allowedExtensions,
                          );

                          if (result != null) {
                            selectedFile = File(result.files.single.path ?? "");
                          } else {}

                          gc.update(["order_file_list"]);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 1,
                              color: greyColor,
                            ),
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  "select_files".tr,
                                  style: GoogleFonts.quicksand(
                                    color: greyColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(9),
                                    bottomRight: Radius.circular(9),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.folder_copy_outlined,
                                      color: whiteColor,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "file_select".tr,
                                      style: GoogleFonts.quicksand(color: whiteColor),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  // controller: gc.projectDescriptionController,
                  onSaved: (value) {
                    gc.formData['details'] = value;
                  },
                  maxLines: 5,
                  initialValue: widget.order?.details ?? "",
                  decoration: InputDecoration(
                    labelText: "detail".tr,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: greyColor,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                Container(),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () async {
                    if (formkey.currentState!.validate()) {
                      formkey.currentState!.save();
                      gc.formData['file_path'] = selectedFile?.path;
                      bool result = false;
                      String action = "";

                      Map<String, dynamic> data = {
                        "title": gc.formData["title"],
                        "price": gc.formData["price"] ?? 0,
                        "customer": gc.formData["customer"],
                        "percentage": gc.formData["percentage"],
                        "start_date": gc.formData["start_date"],
                        "delivery_date": gc.formData["delivery_date"],
                        "status": gc.formData["status"],
                        "urgency": gc.formData["urgency"],
                        "details": gc.formData["details"],
                        "file_path": await fileUpload(gc.formData["file_path"]),
                        "source": 3,
                        "lastupdate": DateTime.now().toString()
                      };

                      if (widget.order != null) {
                        data['id'] = widget.order!.id.toString();
                        result = await oc.updateOrder(data);
                        action = "updated".tr;
                      } else {
                        result = await oc.addOrder(data);
                        action = "created".tr;
                      }

                      if (result) {
                        showSnackBar(
                            context,
                            "success".tr,
                            "order_action_success".trParams(
                              {'action': action},
                            ),
                            1);
                        gc.formData.clear();
                        gc.sc.page.value = const Orders();
                      } else {
                        showSnackBar(
                            context,
                            "error".tr,
                            "order_action_error".trParams(
                              {'action': action},
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
                        const Icon(Icons.save_outlined, color: Colors.white),
                        const SizedBox(width: 5),
                        Text("save".tr, style: GoogleFonts.quicksand(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
