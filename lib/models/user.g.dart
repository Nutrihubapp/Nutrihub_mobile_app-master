// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User()
    ..userId = json['user_id'] as String
    ..name = json['name'] as String
    ..email = json['email'] as String
    ..userRole = json['user_role'] as String
    ..phone = json['phone'] as String
    ..address = json['address'] as String
    ..about = json['about'] as String
    ..photo = json['photo'] as String
    ..message = json['message'] as String
    ..status = json['status'] as num
    ..validity = json['validity'] as bool
    ..token = json['token'] as String;
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'user_id': instance.userId,
      'name': instance.name,
      'email': instance.email,
      'user_role': instance.userRole,
      'phone': instance.phone,
      'address': instance.address,
      'about': instance.about,
      'photo': instance.photo,
      'message': instance.message,
      'status': instance.status,
      'validity': instance.validity,
      'token': instance.token
    };
