import 'package:get/get.dart';
import 'package:orderproject/controller/state/global_controller.dart';
import 'package:orderproject/model/customer.dart';

import 'db/db_controller.dart';

class CustomerController {
  GlobalController gc = Get.find();
  DB db = DB();
  Future<List<CustomerModel>> customerList() async {
    var sonuc = await db.select("SELECT * FROM customer");
    return sonuc.map((e) => CustomerModel.fromJson(e)).toList().toList();
  }

  Future<bool> addCustomer({Map? formData}) async {
    formData ??= gc.formData;
    Map<String, dynamic> data = {
      "name": formData["customer_name"],
      "mail": formData["customer_mail"],
      "phone": formData["customer_phone"],
      "lastupdate": DateTime.now().toString(),
    };

    return await db.insert("customer", data);
  }

  Future<bool> updateCustomer({Map? formData}) async {
    formData ??= gc.formData;
    Map<String, dynamic> data = {
      "name": formData["customer_name"],
      "mail": formData["customer_mail"],
      "phone": formData["customer_phone"],
      "lastupdate": DateTime.now().toString(),
    };

    return await db.updateData("customer", data, "cus_id = ${formData["customer_id"]}");
  }

  Future<CustomerModel> select(int id) async {
    var rows = await db.select("SELECT * FROM customer WHERE cus_id = $id");
    return CustomerModel.fromJson(rows[0]);
  }

  Future<bool> deleteCustomer(int id) async {
    return await db.delete("customer", ["cus_id"], [id]);
  }

  deleteCustomerList(List<String> list) async {
    return await db.select("DELETE FROM customer WHERE cus_id IN (${list.join(",")})");
  }
}
