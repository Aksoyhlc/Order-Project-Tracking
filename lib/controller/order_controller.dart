import 'package:orderproject/model/order.dart';

import 'db/db_controller.dart';

class OrderController {
  DB db = DB();
  Future<List<OrderModel>> orderList() async {
    var sonuc = await db.select(
        "SELECT orders.*, customer.name, customer.phone FROM orders LEFT JOIN customer ON orders.customer = customer.cus_id ORDER BY id DESC");
    return sonuc.map((e) => OrderModel.fromJson(e)).toList().toList();
  }

  Future<bool> addOrder(Map<String, dynamic> formData) async {
    formData["created_date"] = DateTime.now().toString();
    return await db.insert("orders", formData);
  }

  Future<bool> updateOrder(Map<String, dynamic> formData) async {
    return await db.updateData("orders", formData, "id = ${formData["id"]}");
  }

  Future<OrderModel> select(int id) async {
    var rows = await db.select("SELECT * FROM orders WHERE id = $id");
    return OrderModel.fromJson(rows[0]);
  }

  Future<bool> deleteOrder(int id) async {
    return await db.delete("orders", ["id"], [id]);
  }

  deleteOrderList(List<String> list) async {
    return await db.select("DELETE FROM orders WHERE id IN (${list.join(",")})");
  }
}
