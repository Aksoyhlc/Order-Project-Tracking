import 'package:orderproject/helper/string_helper.dart';

class ProjectModel {
  String? createdDate;
  String? detail;
  String? endDate;
  String? filePath;
  int? id;
  String? lastUpdate;
  String? percentage;
  int? priority;
  int? source;
  String? startDate;
  int? status;
  String? title;

  ProjectModel(
      {this.createdDate,
      this.detail,
      this.endDate,
      this.filePath,
      this.id,
      this.lastUpdate,
      this.percentage,
      this.priority,
      this.source,
      this.startDate,
      this.status,
      this.title});

  ProjectModel.fromJson(Map json) {
    createdDate = json['created_date'];
    detail = json['detail'];
    endDate = json['end_date'];
    filePath = json['file_path'];
    id = json['id'];
    lastUpdate = json['last_update'];
    percentage = json['percentage'].toString();
    priority = json['priority'].toString().toInt ?? 0;
    source = json['source'];
    startDate = json['start_date'];
    status = json['status'].toString().toInt ?? 0;
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map();
    data['created_date'] = this.createdDate;
    data['detail'] = this.detail;
    data['end_date'] = this.endDate;
    data['file_path'] = this.filePath;
    data['id'] = this.id;
    data['last_update'] = this.lastUpdate;
    data['percentage'] = this.percentage;
    data['priority'] = this.priority;
    data['source'] = this.source;
    data['start_date'] = this.startDate;
    data['status'] = this.status;
    data['title'] = this.title;
    return data;
  }
}
