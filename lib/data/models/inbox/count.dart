import 'package:equatable/equatable.dart';

class InboxCountModel {
  int? status;
  bool? error;
  String? message;
  InboxCountData? data;

  InboxCountModel({
    this.status,
    this.error,
    this.message,
    this.data,
  });

  factory InboxCountModel.fromJson(Map<String, dynamic> json) =>
    InboxCountModel(
      status: json["status"],
      error: json["error"],
      message: json["message"],
      data: InboxCountData.fromJson(json["data"]),
    );
}

class InboxCountData extends Equatable{
  final int? total;

  const InboxCountData({
    this.total,
  });

  factory InboxCountData.fromJson(Map<String, dynamic> json) => InboxCountData(
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "total": total,
  };

  @override
  List<Object?> get props => [
    total,
  ];
}
