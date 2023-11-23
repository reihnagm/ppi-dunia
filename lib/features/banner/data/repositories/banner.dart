import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:ppidunia/features/banner/data/models/banner.dart';
import 'package:ppidunia/common/errors/exceptions.dart';
import 'package:ppidunia/common/consts/api_const.dart';
import 'package:ppidunia/common/utils/dio.dart';

class BannerRepo {
  Dio? dioClient;

  BannerRepo({required this.dioClient}) {
    dioClient ??= DioManager.shared.getClient();
  }

  Future<BannerModel?> getBanner() async {
    try {
      Response res = await dioClient!.get("${ApiConsts.baseUrl}/api/v1/banner");
      Map<String, dynamic> dataJson = res.data;
      BannerModel data = BannerModel.fromJson(dataJson);
      return data;
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioException(e).toString();
      throw CustomException(errorMessage);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }
}
