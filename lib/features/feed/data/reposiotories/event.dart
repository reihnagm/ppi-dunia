import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ppidunia/common/errors/exceptions.dart';
import 'package:ppidunia/common/utils/dio.dart';
import 'package:ppidunia/common/utils/shared_preferences.dart';
import 'package:ppidunia/features/feed/data/models/event.dart';

class EventRepo {
  Dio? dioClient;

  EventRepo({required this.dioClient}) {
    dioClient ??= DioManager.shared.getClient();
  }

  Future<EventModel> getEvent() async {
    try {
      Response res = await dioClient!.post("/api/v1/event", data: {
        "user_id": SharedPrefs.getUserId()
      });
      Map<String, dynamic> data = res.data;
      EventModel em = EventModel.fromJson(data);
      return em;
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioException(e).toString();
      throw CustomException(errorMessage);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }
}