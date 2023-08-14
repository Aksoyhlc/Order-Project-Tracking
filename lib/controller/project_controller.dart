import 'package:orderproject/model/project.dart';

import 'db/db_controller.dart';

class ProjectController {
  DB db = DB();
  Future<List<ProjectModel>> cprojectList() async {
    var sonuc = await db.select("SELECT * FROM project");
    return sonuc.map((e) => ProjectModel.fromJson(e)).toList().toList();
  }

  Future<bool> addProject(Map<String, dynamic> formData) async {
    formData["created_date"] = DateTime.now().toString();
    return await db.insert("project", formData);
  }

  Future<bool> updateProject(Map<String, dynamic> formData) async {
    return await db.updateData("project", formData, "id = ${formData["id"]}");
  }

  Future<ProjectModel> select(int id) async {
    var rows = await db.select("SELECT * FROM project WHERE id = $id");
    return ProjectModel.fromJson(rows[0]);
  }

  Future<bool> delete(int id) async {
    return await db.delete("project", ["id"], [id]);
  }

  deleteProjectList(List<String> list) async {
    return await db.select("DELETE FROM project WHERE id IN (${list.join(",")})");
  }
}
