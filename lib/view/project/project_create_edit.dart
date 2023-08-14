import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:orderproject/controller/project_controller.dart';
import 'package:orderproject/controller/state/sidebar_controller.dart';
import 'package:orderproject/model/project.dart';
import 'package:orderproject/view/project/projects.dart';

import '../../const/const.dart';
import '../../const/ext.dart';
import '../../controller/state/global_controller.dart';
import '../partial/card.dart';
import '../partial/dropdown.dart';
import '../partial/text_input.dart';

class ProjectCreateEdit extends StatefulWidget {
  final ProjectModel? project;

  const ProjectCreateEdit({super.key, this.project});

  @override
  State<ProjectCreateEdit> createState() => _ProjectCreateEditState();
}

class _ProjectCreateEditState extends State<ProjectCreateEdit> {
  GlobalKey<FormState> formkey = GlobalKey();
  GlobalController gc = Get.find<GlobalController>();
  ProjectController pc = ProjectController();
  File? selectedFile;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gc.formData.clear();
    gc.dataController.clear();
    if (widget.project != null) {
      selectedFile =
          widget.project?.filePath == null ? null : File(gc.documentDirectory.value + fileUploadFolderName + (widget.project?.filePath ?? ""));
      gc.formData.addAll({
        'title': widget.project!.title,
        'percentage': widget.project!.percentage,
        'start_date': widget.project!.startDate,
        'end_date': widget.project!.endDate,
        'status': widget.project!.status,
        'priority': widget.project!.priority,
        'detail': widget.project!.detail,
        'file_path': widget.project!.filePath,
        'source': widget.project!.source,
        'last_update': widget.project!.lastUpdate,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      title: "project_create".tr,
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
                      hintText: "project_title".tr,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "project_title_not_empty".tr;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(width: 20),
                    CustomTextInput(
                      name: "percentage",
                      labelText: "percent".tr,
                      hintText: "percent_desc".tr,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "project_percent_not_empty".tr;
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
                          return "start_date_not_empty".tr;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(width: 20),
                    CustomTextInput(
                      name: "end_date",
                      labelText: "end_date".tr,
                      hintText: "end_date".tr,
                      keyboardType: TextInputType.datetime,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "end_date_not_empty".tr;
                        }
                        return null;
                      },
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
                        selectKey: (widget.project?.status ?? 0).toString(),
                        onSelect: (key, value) {
                          gc.formData["status"] = key;
                        },
                        onInit: () {
                          gc.formData["status"] = (widget.project?.status ?? 0).toString();
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
                    SizedBox(width: isMobileSize() ? 0 : 20),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: CustomDropDownMenu(
                        maxWidth: 0.25.sw,
                        items: {for (var e in Urgency.values) e.index.toString(): e.toString().split(".").last.toLowerCase().tr},
                        labelText: "urgency".tr,
                        selectKey: (widget.project?.priority ?? 0).toString(),
                        onSelect: (key, value) {
                          gc.formData["priority"] = key;
                        },
                        onInit: () {
                          gc.formData["priority"] = (widget.project?.priority ?? 0).toString();
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
                SizedBox(
                  width: isMobileSize() ? double.infinity : 0.33.sw,
                  child: Column(
                    children: [
                      GetBuilder<GlobalController>(
                        init: gc,
                        id: "project_file_list",
                        builder: (logic) {
                          String fileName = "";
                          if (selectedFile != null) {
                            if (selectedFile!.path.contains("\\")) {
                              fileName = selectedFile!.path.split("\\").last;
                            } else if (selectedFile!.path.contains("/")) {
                              fileName = selectedFile!.path.split("/").last;
                            } else {
                              fileName = selectedFile!.path;
                            }
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
                                          fileName,
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
                                          gc.update(["project_file_list"]);
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

                          gc.update(["project_file_list"]);
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
                    gc.formData['detail'] = value;
                  },
                  maxLines: 5,
                  initialValue: widget.project?.detail ?? "",
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
                        "percentage": gc.formData["percentage"],
                        "start_date": gc.formData["start_date"],
                        "end_date": gc.formData["end_date"],
                        "status": gc.formData["status"],
                        "priority": gc.formData["priority"],
                        "detail": gc.formData["detail"],
                        "file_path": await fileUpload(gc.formData["file_path"]),
                        "source": 3,
                        "last_update": DateTime.now().toString()
                      };

                      if (widget.project != null) {
                        data['id'] = widget.project!.id.toString();
                        result = await pc.updateProject(data);
                        action = "updated".tr;
                      } else {
                        result = await pc.addProject(data);
                        action = "created".tr;
                      }

                      if (result) {
                        showSnackBar(context, "success".tr, "project_action_success".trParams({"action": action}), 1);
                        gc.formData.clear();
                        SidebarController sc = Get.find();
                        sc.pageChange(const Projects());
                      } else {
                        showSnackBar(context, "error".tr, "project_action_error".trParams({"action": action}), 0);
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
