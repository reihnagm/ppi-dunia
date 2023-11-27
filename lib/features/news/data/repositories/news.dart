import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:ppidunia/features/news/data/models/news.dart';
import 'package:ppidunia/features/news/data/models/single_news.dart';
import 'package:ppidunia/common/errors/exceptions.dart';
import 'package:ppidunia/common/consts/api_const.dart';
import 'package:ppidunia/common/utils/dio.dart';

class NewsRepo {
  Dio? dioClient;

  //TODO: implement semua repo begini, full untuk api request aja & return data/void
  //biar nanti di provider yang handle logicnya setelah dapat data/request dari api
  NewsRepo({
    required this.dioClient,
  }) {
    dioClient ??= DioManager.shared.getClient();
  }

  Future<NewsModel?> getNews() async {
    try {
      Response res = await dioClient!.get("${ApiConsts.baseUrl}/api/v1/news");
      NewsModel data = NewsModel.fromJson(res.data);
      return data;
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioException(e).toString();
      throw CustomException(errorMessage);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<SingleNewsModel?> getNewsDetail(BuildContext context,
      {required String newsId}) async {
    try {
      Response res = await dioClient!
          .get("${ApiConsts.baseUrl}/api/v1/news/detail/$newsId");
      SingleNewsModel data = SingleNewsModel.fromJson(res.data);
      return data;
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioException(e).toString();
      throw CustomException(errorMessage);
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }
}
