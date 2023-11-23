import 'package:dio/dio.dart';

import 'package:ppidunia/common/utils/dio.dart';
import 'package:ppidunia/common/errors/exceptions.dart';
import 'package:ppidunia/common/utils/shared_preferences.dart';

import '../../../feed/data/models/feed.dart';

class BookmarkRepo {
  Dio? dioClient;

  BookmarkRepo({required this.dioClient}) {
    dioClient ??= DioManager.shared.getClient();
  }

  Future<FeedModel> getFeeds(
      {required int pageKey, required String search}) async {
    try {
      Response res = await dioClient!.get(
          "/api/v1/feed/bookmark/all?page=$pageKey&limit=10&search=$search",
          options: Options(headers: {"USERID": SharedPrefs.getUserId()}));
      Map<String, dynamic> data = res.data;
      FeedModel fm = FeedModel.fromJson(data);
      return fm;
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioException(e).toString();
      throw CustomException(errorMessage);
    } catch (e) {
      throw CustomException(e.toString());
    }
  }
}
