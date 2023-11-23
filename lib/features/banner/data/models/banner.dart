import 'package:equatable/equatable.dart';

class BannerModel {
  int? status;
  bool? error;
  String? message;
  List<BannerData>? data;

  BannerModel({
    this.status,
    this.error,
    this.message,
    this.data,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
    status: json["status"],
    error: json["error"],
    message: json["message"],
    data: List<BannerData>.from(json["data"].map((x) => BannerData.fromJson(x))),
  );
}

class BannerData extends Equatable {
  final String? uid;
  final String? name;
  final String? path;
  final String? createdAt;

  const BannerData({
    this.uid,
    this.name,
    this.path,
    this.createdAt,
  });

  factory BannerData.fromJson(Map<String, dynamic> json) => BannerData(
    uid: json["uid"],
    name: json["name"],
    path: json["path"],
    createdAt: json["created_at"],
  );

  @override
  List<Object?> get props => [
    uid,
    name,
    path,
    createdAt,
  ];
}
