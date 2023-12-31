import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ppidunia/features/maintenance/data/model/demo.dart';
import 'package:ppidunia/features/maintenance/data/model/maintenance.dart';
import 'package:ppidunia/common/consts/api_const.dart';
import 'package:ppidunia/common/utils/dio.dart';
import 'package:ppidunia/common/errors/exceptions.dart';

class MaintenanceRepo {
  Dio? dioClient;

  MaintenanceRepo({required this.dioClient}) {
    dioClient ??= DioManager.shared.getClient();
  }

  Future<MaintenanceModel?> getMaintenanceStatus(BuildContext context) async {
    try {
      Response res =
          await dioClient!.get("${ApiConsts.baseUrl}/api/v1/maintenance");
      MaintenanceModel dataJson = MaintenanceModel.fromJson(res.data);
      return dataJson;
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioException(e).toString();
      throw CustomException(errorMessage);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      debugPrint(e.toString());
      throw CustomException(e.toString());
    }
  }

  Future<DemoModel?> getDemoStatus(BuildContext context) async {
    try {
      Response res = await dioClient!
          .get("${ApiConsts.baseUrl}/api/v1/maintenance/show-demo");
      DemoModel dataJson = DemoModel.fromJson(res.data);
      return dataJson;
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioException(e).toString();
      throw CustomException(errorMessage);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      debugPrint(e.toString());
      throw CustomException(e.toString());
    }
  }
}
