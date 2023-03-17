import 'dart:convert';

UpdateUserModel updateUserModelFromJson(String str) => UpdateUserModel.fromJson(json.decode(str));

String updateUserModelToJson(UpdateUserModel data) => json.encode(data.toJson());

class UpdateUserModel {
  UpdateUserModel({
    this.message,
    this.status,
    this.validity,
  });

  String? message;
  int? status;
  bool? validity;

  factory UpdateUserModel.fromJson(Map<String, dynamic> json) => UpdateUserModel(
    message: json["message"],
    status: json["status"],
    validity: json["validity"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status": status,
    "validity": validity,
  };
}