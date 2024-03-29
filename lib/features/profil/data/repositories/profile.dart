import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:ppidunia/features/profil/data/models/profile.dart';
import 'package:ppidunia/features/feed/data/models/feed.dart';

import 'package:ppidunia/common/utils/dio.dart';
import 'package:ppidunia/common/errors/exceptions.dart';
import 'package:ppidunia/common/utils/shared_preferences.dart';
import 'package:ppidunia/features/profil/data/models/mention.dart';

class ProfileRepo {
  Dio? dioClient;

  ProfileRepo({required this.dioClient}) {
    dioClient ??= DioManager.shared.getClient();
  }

  Future<FeedModel> getFeeds(
      {required int pageKey, required String search}) async {
    try {
      Response res = await dioClient!.get(
          "/api/v1/feed?page=$pageKey&limit=10&branch=&search=$search&feed_highlight_type=SELF",
          options: Options(headers: {"USERID": SharedPrefs.getUserId()}));
      Map<String, dynamic> data = res.data;
      FeedModel fm = FeedModel.fromJson(data);
      return fm;
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioException(e).toString();
      throw CustomException(errorMessage);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<FeedModel> getFeedsUser(
      {required int pageKey,
      required String search,
      required String userId}) async {
    try {
      Response res = await dioClient!.get("/api/v1/feed?page=$pageKey&limit=10&branch=&search=$search&feed_highlight_type=SELF",
          options: Options(headers: {"USERID": userId}));
      Map<String, dynamic> data = res.data;
      FeedModel fm = FeedModel.fromJson(data);
      return fm;
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioException(e).toString();
      throw CustomException(errorMessage);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<ProfileModel?> getProfile({required String userId}) async {
    try {
      Response res = await dioClient!.post("/api/v1/profile", data: {
        "user_id": userId,
      });
      Map<String, dynamic> data = res.data;
      ProfileModel p = ProfileModel.fromJson(data);
      return p;
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioException(e).toString();
      throw CustomException(errorMessage);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<ProfileModel?> getProfileUser({required String userId}) async {
    try {
      Response res = await dioClient!.post("/api/v1/profile", data: {
        "user_id": userId,
      });
      Map<String, dynamic> data = res.data;
      ProfileModel p = ProfileModel.fromJson(data);
      return p;
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioException(e).toString();
      throw CustomException(errorMessage);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<void> updateProfilePicture(
      {required String avatar, required String userId}) async {
    try {
      await dioClient!.post("/api/v1/profile/update", data: {
        "avatar": avatar,
        "user_id": userId,
      });
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioException(e).toString();
      throw CustomException(errorMessage);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<void> updateProfile({
    required String firtNameC,
    required String lastNameC,
    required String email,
    required String userId,
    required String phone,
  }) async {
    try {
      await dioClient!.post("/api/v1/profile/update", data: {
        "first_name": firtNameC,
        "last_name": lastNameC,
        "email": email,
        "phone": phone,
        "user_id": userId,
      });
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioException(e).toString();
      throw CustomException(errorMessage);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<void> jointEvent(
    {
      required String eventId,
      required String firtNameC,
      required String lastNameC,
      required String email,
      required String phone,
      required String gender,
      required String status,
      required String instution,
    }) async {
    try {
      await dioClient!.post("/api/v1/event/create-register", data: {
        "event_id": eventId,
        "user_id": SharedPrefs.getUserId(),
        "first_name": firtNameC,
        "last_name": lastNameC,
        "email": email,
        "phone": phone,
        "gender": gender,
        "status": status,
        "agency": instution,
      });
      debugPrint("Berhasil Daftar Event");
      // await joinedEvent(eventId: eventId);
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioException(e).toString();
      throw CustomException(errorMessage);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<void> joinedEvent({required String eventId}) async {
    try {
      await dioClient!.post('/api/v1/event/join', data: {
        "user_id": SharedPrefs.getUserId(),
        "event_id": eventId
      });
      debugPrint("Berhasil Report Postingan");
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioException(e).toString();
      throw CustomException(errorMessage);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<GetUserMention> getUserMention({required int pageKey, required String search}) async {
    try {
      Response res = await dioClient!.post("/api/v1/profile/all?search=$search&page=$pageKey&limit=400", data: {
        "user_id": SharedPrefs.getUserId(),
      });
      Map<String, dynamic> data = res.data;
      GetUserMention user = GetUserMention.fromJson(data);
      return user;
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioException(e).toString();
      throw CustomException(errorMessage);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<void> deleteAccount({required String userId}) async {
    try {
      await dioClient!.post("/api/v1/auth/delete", data: {
        "user_id": userId,
      });
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioException(e).toString();
      throw CustomException(errorMessage);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }
}
