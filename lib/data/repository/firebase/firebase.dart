import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:ppidunia/utils/exceptions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ppidunia/utils/dio.dart';
import 'package:ppidunia/utils/constant.dart';

class FirebaseRepo {
  Dio? dioClient;

  FirebaseRepo({required this.dioClient}) {
    dioClient ??= DioManager.shared.getClient();
  }

  Future<void> initFcm({ required String userId, required String lat, required String lng}) async {
    try {
      Response res = await dioClient!.post("${AppConstants.baseUrl}/api/v1/fcm", 
        data: {
          "user_id": userId,
          "token": await FirebaseMessaging.instance.getToken(),
          "lat": lat,
          "lng": lng,
        }
      );
      debugPrint("Initialize FCM : ${res.statusCode}");
    } on DioException catch(e) {
      final errorMessage = DioExceptions.fromDioException(e).toString();
      throw CustomException(errorMessage);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }
}