class CustomerModel {
  int? cusId;
  String? lastupdate;
  String? mail;
  String? name;
  String? phone;
  int? source;

  CustomerModel({this.cusId, this.lastupdate, this.mail, this.name, this.phone, this.source});

  CustomerModel.fromJson(Map json) {
    cusId = json['cus_id'];
    lastupdate = json['lastupdate'];
    mail = json['mail'];
    name = json['name'];
    phone = json['phone'];
    source = json['source'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map();
    data['cus_id'] = this.cusId;
    data['lastupdate'] = this.lastupdate;
    data['mail'] = this.mail;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['source'] = this.source;
    return data;
  }
}
