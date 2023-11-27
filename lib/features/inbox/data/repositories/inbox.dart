import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'package:ppidunia/features/inbox/data/models/count.dart';
import 'package:ppidunia/features/inbox/data/models/inbox.dart';

import 'package:ppidunia/common/errors/exceptions.dart';
import 'package:ppidunia/common/utils/dio.dart';

class InboxRepo {
  Dio? dioClient;

  InboxRepo({required this.dioClient}) {
    dioClient ??= DioManager.shared.getClient();
  }
 
  Future<InboxModel> getInbox({required String userId, required String type, required int pageKey}) async {
    try {
      Response res = await dioClient!.post("/api/v1/inbox?page=$pageKey", data: {
        "user_id": userId,
        "type": type,
      });
      Map<String, dynamic> data = res.data;
      InboxModel im = InboxModel.fromJson(data);
      return im;
    } on DioException catch(e) {
      final errorMessage = DioExceptions.fromDioException(e).toString();
      throw CustomException(errorMessage);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(stacktrace.toString());
    }
  }

  Future<InboxCountModel> getInboxCount({required String userId}) async {
    try {
      Response res = await dioClient!.post("/api/v1/inbox/badges", data: {
        "user_id": userId,
      });
      Map<String, dynamic> data = res.data;
      InboxCountModel icm = InboxCountModel.fromJson(data);
      return icm;
    } on DioException catch(e) {
      final errorMessage = DioExceptions.fromDioException(e).toString();
      throw CustomException(errorMessage);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<void> updateInbox({required String inboxId, required String userId}) async {
    try {
      await dioClient!.post("/api/v1/inbox/detail", data: {
        "id": inboxId,
        "user_id": userId,
      });
    } on DioException catch(e) {
      final errorMessage = DioExceptions.fromDioException(e).toString();
      throw CustomException(errorMessage);
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }
}