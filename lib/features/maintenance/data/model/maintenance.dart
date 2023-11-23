import 'package:equatable/equatable.dart';

class MaintenanceModel {
    MaintenanceModel({
        this.status,
        this.error,
        this.message,
        this.data,
    });

    int? status;
    bool? error;
    String? message;
    MaintenanceData? data;

    factory MaintenanceModel.fromJson(Map<String, dynamic> json) => MaintenanceModel(
        status: json["status"],
        error: json["error"],
        message: json["message"],
        data: MaintenanceData.fromJson(json["data"]),
    );
}

class MaintenanceData extends Equatable{
    const MaintenanceData({
        this.maintenance,
    });

    final bool? maintenance;

    factory MaintenanceData.fromJson(Map<String, dynamic> json) => MaintenanceData(
        maintenance: json["maintenance"] ?? false,
    );

    Map<String, dynamic> toJson() => {
      "maintenance": maintenance,
    };

    @override
    List<Object?> get props => [
        maintenance,
    ];
}
