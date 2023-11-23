import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:ppidunia/common/errors/exceptions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ppidunia/common/utils/dio.dart';
import 'package:ppidunia/common/consts/api_const.dart';

class FirebaseRepo {
  Dio? dioClient;

  FirebaseRepo({required this.dioClient}) {
    dioClient ??= DioManager.shared.getClient();
  }

  Future<void> initFcm(
      {required String userId,
      required String lat,
      required String lng}) async {
    try {
      Response res =
          await dioClient!.post("${ApiConsts.baseUrl}/api/v1/fcm", data: {
        "user_id": userId,
        "token": await FirebaseMessaging.instance.getToken(),
        "lat": lat,
        "lng": lng,
      });
      debugPrint("Initialize FCM : ${res.statusCode}");
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioException(e).toString();
      throw CustomException(errorMessage);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }
}
