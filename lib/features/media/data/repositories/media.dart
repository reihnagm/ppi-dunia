import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

import 'package:ppidunia/common/errors/exceptions.dart';
import 'package:ppidunia/common/consts/api_const.dart';
import 'package:ppidunia/common/utils/dio.dart';

class MediaRepo {
  Dio? dioClient;

  MediaRepo({required this.dioClient}) {
    dioClient ??= DioManager.shared.getClient();
  }

  Future<Map<String, dynamic>> postMedia(
      {required String folder, required File media}) async {
    try {
      FormData formData = FormData.fromMap({
        "folder": folder,
        "media": await MultipartFile.fromFile(media.path,
            filename: p.basename(media.path)),
      });
      Response res = await dioClient!
          .post("${ApiConsts.baseUrl}/api/v1/media", data: formData);
      Map<String, dynamic> data = res.data;
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
