import 'package:flutter_bloc_boilerplate/features/auth/domain/entities/user.dart';

class UserModel extends User {
  UserModel({required super.id, required super.email});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(id: json['id'], email: json['email']);
  }

  Map<String, dynamic> toJson() => {'id': id, 'email': email};
}
