import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:ppidunia/features/feed/data/models/feed.dart' as f;
import 'package:ppidunia/features/country/data/models/branch.dart';
import 'package:ppidunia/features/country/data/models/country.dart';

import 'package:ppidunia/common/utils/dio.dart';
import 'package:ppidunia/common/errors/exceptions.dart';
import 'package:ppidunia/common/utils/shared_preferences.dart';

class FeedRepo {
  Dio? dioClient;

  FeedRepo({required this.dioClient}) {
    dioClient ??= DioManager.shared.getClient();
  }

  Future<void> post({
    required String feedId,
    required String caption,
    required String feedType,
    required String countryId,
  }) async {
    try {
      Object data = {
        "feed_id": feedId,
        "caption": caption,
        "feed_type": feedType,
        "user_id": SharedPrefs.getUserId(),
        "country_id": countryId
      };

      await dioClient!.post("/api/v1/feed", data: data);
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioException(e).toString();
      throw CustomException(errorMessage);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<void> toggleLike({required String feedId}) async {
    try {
      Object data = {"feed_id": feedId, "user_id": SharedPrefs.getUserId()};

      await dioClient!.post("/api/v1/feed/like", data: data);
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioException(e).toString();
      throw CustomException(errorMessage);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<void> toggleBookmark({required String feedId}) async {
    try {
      Object data = {"feed_id": feedId, "user_id": SharedPrefs.getUserId()};

      await dioClient!.post("/api/v1/feed/bookmark", data: data);
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioException(e).toString();
      throw CustomException(errorMessage);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<void> postMedia(
      {required String feedId,
      required String path,
      required String size}) async {
    try {
      await dioClient!.post("/api/v1/feed/media",
          data: {"feed_id": feedId, "path": path, "size": size});
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioException(e).toString();
      throw CustomException(errorMessage);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<f.FeedModel> getFeeds(
      {required int pageKey,
      required String branch,
      required String search}) async {
    try {
      Response res = await dioClient!.get(
          "/api/v1/feed?page=$pageKey&limit=10&branch=$branch&search=$search");
      Map<String, dynamic> data = res.data;
      f.FeedModel fm = f.FeedModel.fromJson(data);
      return fm;
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioException(e).toString();
      throw CustomException(errorMessage);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<BranchModel> getFeedTag() async {
    try {
      Response res = await dioClient!.get('/api/v1/country/branch');
      Map<String, dynamic> data = res.data;
      BranchModel cm = BranchModel.fromJson(data);
      return cm;
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioException(e).toString();
      throw CustomException(errorMessage);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<BranchModel> getBranches() async {
    try {
      Response res = await dioClient!.get('/api/v1/country/branch');
      Map<String, dynamic> data = res.data;
      BranchModel cm = BranchModel.fromJson(data);
      return cm;
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioException(e).toString();
      throw CustomException(errorMessage);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }
  Future<void> reportUser({required String feedId, required String content}) async {
    try {
      await dioClient!.post('/api/v1/feed/create-report', data: {
        "feed_id": feedId,
        "user_id": SharedPrefs.getUserId(),
        "name": content
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

  Future<CountryModel> getCountries() async {
    try {
      Response res = await dioClient!.get('/api/v1/country');
      Map<String, dynamic> data = res.data;
      CountryModel cm = CountryModel.fromJson(data);
      return cm;
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioException(e).toString();
      throw CustomException(errorMessage);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<void> feedDelete({required String feedId}) async {
    try {
      await dioClient!.get("/api/v1/feed/delete/$feedId");
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioException(e).toString();
      throw CustomException(errorMessage);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }
}
