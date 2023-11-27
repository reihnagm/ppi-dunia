import 'package:equatable/equatable.dart';

class DemoModel {
  DemoModel({
    this.status,
    this.error,
    this.message,
    this.data,
  });

  int? status;
  bool? error;
  String? message;
  DemoData? data;

  factory DemoModel.fromJson(Map<String, dynamic> json) => DemoModel(
    status: json["status"],
    error: json["error"],
    message: json["message"],
    data: DemoData.fromJson(json["data"]),
  );
}

class DemoData extends Equatable{
  const DemoData({
    this.showDemo,
  });

  final bool? showDemo;

  factory DemoData.fromJson(Map<String, dynamic> json) => DemoData(
    showDemo: json["show_demo"],
  );

  Map<String, dynamic> toJson() => {
    "show_demo": showDemo,
  };

  @override
  List<Object?> get props => [
    showDemo,
  ];
}