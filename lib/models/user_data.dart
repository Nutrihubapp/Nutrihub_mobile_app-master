class UserData {
  String? userId;
  String? name;
  String? email;
  String? role;
  String? phone;
  String? address;
  String? about;
  String? photo;
  String? message;
  int? status;
  bool? validity;

  UserData(
      {this.userId,
      this.name,
      this.email,
      this.role,
      this.phone,
      this.address,
      this.about,
      this.photo,
      this.message,
      this.status,
      this.validity});

  UserData.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    name = json['name'];
    email = json['email'];
    role = json['role'];
    phone = json['phone'];
    address = json['address'];
    about = json['about'];
    photo = json['photo'];
    message = json['message'];
    status = json['status'];
    validity = json['validity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['name'] = name;
    data['email'] = email;
    data['role'] = role;
    data['phone'] = phone;
    data['address'] = address;
    data['about'] = about;
    data['photo'] = photo;
    data['message'] = message;
    data['status'] = status;
    data['validity'] = validity;
    return data;
  }
}
