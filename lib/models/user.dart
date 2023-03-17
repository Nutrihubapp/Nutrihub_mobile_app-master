import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  String? userId;
  String? name;
  String? email;
  String? userRole;
  String? phone;
  String? address;
  String? about;
  String? photo;
  String? message;
  num? status;
  bool? validity;
  String? token;

  User(
      {this.userId,
      this.name,
      this.email,
      this.userRole,
      this.phone,
      this.address,
      this.about,
      this.photo,
      this.message,
      this.status,
      this.validity,
      this.token});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
