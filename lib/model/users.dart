class UserModel {
  String? email;
  int? id;
  String? lastupdate;
  String? name;
  String? password;
  int? source;

  UserModel({this.email, this.id, this.lastupdate, this.name, this.password, this.source});

  UserModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    id = json['id'];
    lastupdate = json['lastupdate'];
    name = json['name'];
    password = json['password'];
    source = json['source'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['id'] = id;
    data['lastupdate'] = lastupdate;
    data['name'] = name;
    data['password'] = password;
    data['source'] = source;
    return data;
  }
}
