import 'package:orderproject/model/customer.dart';

class OrderModel {
  String? createdDate;
  String? customer;
  String? deliveryDate;
  String? details;
  String? filePath;
  int? id;
  String? lastupdate;
  int? percentage;
  String? price;
  int? source;
  String? startDate;
  int? status;
  String? title;
  int? urgency;
  CustomerModel? customerData;

  OrderModel({
    this.createdDate,
    this.customer,
    this.deliveryDate,
    this.details,
    this.filePath,
    this.id,
    this.lastupdate,
    this.percentage,
    this.price,
    this.source,
    this.startDate,
    this.status,
    this.title,
    this.urgency,
    this.customerData,
  });

  OrderModel.fromJson(Map<String, dynamic> json) {
    createdDate = json['created_date'];
    customer = json['customer'].toString();
    deliveryDate = json['delivery_date'];
    details = json['details'];
    filePath = json['file_path'];
    id = json['id'];
    lastupdate = json['lastupdate'];
    percentage = json['percentage'];
    price = json['price'];
    source = json['source'];
    startDate = json['start_date'];
    status = json['status'];
    title = json['title'];
    urgency = json['urgency'];
    customerData = new CustomerModel.fromJson(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created_date'] = this.createdDate;
    data['customer'] = this.customer;
    data['delivery_date'] = this.deliveryDate;
    data['details'] = this.details;
    data['file_path'] = this.filePath;
    data['id'] = this.id;
    data['lastupdate'] = this.lastupdate;
    data['percentage'] = this.percentage;
    data['price'] = this.price;
    data['source'] = this.source;
    data['start_date'] = this.startDate;
    data['status'] = this.status;
    data['title'] = this.title;
    data['urgency'] = this.urgency;
    if (this.customerData != null) {
      data['customerData'] = this.customerData!.toJson();
    }
    return data;
  }
}
