// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.message,
    this.emailVerificationStatus,
    this.status,
    this.validity,
  });

  String? message;
  String? emailVerificationStatus;
  int? status;
  bool? validity;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    message: json["message"],
    emailVerificationStatus: json["email_verification_status"],
    status: json["status"],
    validity: json["validity"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "email_verification_status": emailVerificationStatus,
    "status": status,
    "validity": validity,
  };
}
