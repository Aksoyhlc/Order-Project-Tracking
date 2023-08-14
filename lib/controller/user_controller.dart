import 'package:get/get.dart';
import 'package:orderproject/controller/state/global_controller.dart';
import 'package:orderproject/main.dart';

import '../model/users.dart';
import 'db/db_controller.dart';

class UserController {
  DB db = DB();

  Future<UserModel> getUser(int id) async {
    var rows = await db.select("SELECT * FROM users WHERE id = $id");
    return UserModel.fromJson(rows[0]);
  }

  Future<UserModel?> login(String mail, String pass) async {
    var rows = await db.select("SELECT * FROM users WHERE email = '$mail' AND password = '" + db.hashPassword(pass) + "'");
    if (rows.length == 0) {
      return null;
    }
    return UserModel.fromJson(rows[0]);
  }

  Future<UserModel> getProfile() async {
    return await getUser(1);
  }

  Future<bool> updateProfile(Map<String, dynamic> formData) async {
    if (formData["password"] == null || formData["password"] == "") {
      formData.remove("password");
    } else {
      formData["password"] = db.hashPassword(formData["password"]);
    }

    return await db.updateData("users", formData, "id = ${formData["id"]}");
  }

  void logout() {
    GlobalController gc = Get.find();
    gc.loginCheck.value = false;
    Get.offAll(() => const MainHomePage());
  }
}
