import 'package:flutter/material.dart';

import 'package:ppidunia/common/utils/dio.dart';
import 'package:ppidunia/common/errors/exceptions.dart';
import 'package:ppidunia/common/utils/shared_preferences.dart';

import 'package:dio/dio.dart';
import 'package:ppidunia/features/feed/data/models/reply.dart';

class ReplyRepo {
  Dio? dioClient;

  ReplyRepo({required this.dioClient}) {
    dioClient ??= DioManager.shared.getClient();
  }

  Future<void> post({required String feedId, required String comment}) async {
    try {
      await dioClient!.post("/api/v1/feed/comment", data: {
        "user_id": SharedPrefs.getUserId(),
        "feed_id": feedId,
        "comment": comment
      });
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioException(e).toString();
      throw CustomException(errorMessage);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<void> postReply(
      {required String feedId,
      required String reply,
      required String commentId}) async {
    try {
      await dioClient!.post("/api/v1/feed/reply", data: {
        "feed_id": feedId,
        "comment_id": commentId,
        "user_id": SharedPrefs.getUserId(),
        "reply": reply
      });
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioException(e).toString();
      throw CustomException(errorMessage);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }
  Future<void> deleteReply(
      {required String deleteId,}) async {
    try {
      await dioClient!.get("/api/v1/feed/reply/delete/$deleteId");
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioException(e).toString();
      throw CustomException(errorMessage);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }
  Future<void> deleteComment(
      {required String deleteId,}) async {
    try {
      await dioClient!.get("/api/v1/feed/comment/delete/$deleteId");
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioException(e).toString();
      throw CustomException(errorMessage);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<ReplyDetailModel> getReplyDetail(
      {required int pageKey, required String commentId}) async {
    try {
      Response res =
          await dioClient!.get("/api/v1/feed/reply/$commentId");
      Map<String, dynamic> data = res.data;
      ReplyDetailModel fm = ReplyDetailModel.fromJson(data);
      return fm;
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioException(e).toString();
      throw CustomException(errorMessage);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }
}
