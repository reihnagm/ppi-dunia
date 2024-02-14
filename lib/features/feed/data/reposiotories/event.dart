import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ppidunia/common/errors/exceptions.dart';
import 'package:ppidunia/common/utils/dio.dart';
import 'package:ppidunia/common/utils/shared_preferences.dart';
import 'package:ppidunia/features/feed/data/models/event.dart';
import 'package:ppidunia/features/feed/data/models/event_detail.dart';
import 'package:ppidunia/features/feed/data/models/user_event_join.dart';

class EventRepo {
  Dio? dioClient;

  EventRepo({required this.dioClient}) {
    dioClient ??= DioManager.shared.getClient();
  }

  Future<EventModel> getEvent(
    {required int pageKey,
      required String branch,
      required String search}
  ) async {
    try {
      Response res = await dioClient!.post("/api/v1/event?page=$pageKey&limit=10&branch=$branch&search=$search", data: {
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
  Future<JoinedEventModel> getEventJoined(
    {required int pageKey,
      required String branch,
      required String search}
  ) async {
    try {
      Response res = await dioClient!.post("/api/v1/event/register/user-joined?page=$pageKey&limit=10&branch=$branch&search=$search", data: {
        "user_id": SharedPrefs.getUserId()
      });
      Map<String, dynamic> data = res.data;
      JoinedEventModel em = JoinedEventModel.fromJson(data);
      return em;
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioException(e).toString();
      throw CustomException(errorMessage);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<EventDetailModel?> getDetailEvent({required String idEvent}) async {
    try {
      Response res = await dioClient!.post("/api/v1/event/detail", data: {
        "id": idEvent,
        "user_id": SharedPrefs.getUserId()
      });
      Map<String, dynamic> data = res.data;
      EventDetailModel em = EventDetailModel.fromJson(data);
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