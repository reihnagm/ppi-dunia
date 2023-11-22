import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'package:ppidunia/utils/dio.dart';
import 'package:ppidunia/utils/exceptions.dart';

class SosRepo {
  Dio? dioClient;
  
  SosRepo({ required this.dioClient }) {
    dioClient ??= DioManager.shared.getClient();
  }

  Future<void> sendSos({
      required String title,
      required String message,
      required String userId,
      required String lat,
      required String lng,
    }) async {
    try {
      await dioClient!.post('/api/v1/sos',
        data: {
          "title": title,
          "message": message,
          "origin_lat": lat,
          "origin_lng": lng,
          "user_id": userId
        }
      );
    } on DioException catch(e) {
      final errorMessage = DioExceptions.fromDioException(e).toString();
      throw CustomException(errorMessage);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

}