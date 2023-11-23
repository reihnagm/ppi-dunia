import 'package:equatable/equatable.dart';

class UserModel {
  final int? status;
  final bool? error;
  final String? message;
  final Data? data;

  UserModel({
    this.status,
    this.error,
    this.message,
    this.data,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    status: json["status"],
    error: json["error"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );
}

class Data {
  final String? token;
  final String? refreshToken;
  final UserData? user;

  Data({
    this.token,
    this.refreshToken,
    this.user,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    token: json["token"],
    refreshToken: json["refresh_token"],
    user: json["user"] == null ? null : UserData.fromJson(json["user"]),
  );
}

class UserData extends Equatable{
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final bool? emailActivated;
  final String? role;

  const UserData({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.emailActivated,
    this.role,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    id: json["id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    email: json["email"],
    emailActivated: json["email_activated"],
    role: json["role"],
  );

  @override
  List<Object?> get props => [
    id,
    firstName,
    lastName,
    email,
    emailActivated,
    role,
  ];
}
