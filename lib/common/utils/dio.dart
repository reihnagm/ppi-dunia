import 'dart:io';

import 'package:dio/io.dart';
import 'package:dio/dio.dart';

import 'package:ppidunia/common/consts/api_const.dart';

class DioManager {
  static final shared = DioManager();

  Dio getClient() {
    Dio dio = Dio();
    dio.httpClientAdapter = IOHttpClientAdapter(createHttpClient: () {
      final client = HttpClient();
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    });
    dio.options.connectTimeout = const Duration(milliseconds: 15000);
    dio.options.baseUrl = ApiConsts.baseUrl;
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add the access token to the request header
          // options.headers['Authorization'] = 'Bearer ${Helper.prefs!.getString("token")}';
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            // If a 401 response is received, refresh the access token
            // String newAccessToken = await refreshToken();

            // Update the request header with the new access token
            // e.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';

            // Repeat the request with the updated header
            // return handler.resolve(await dio.fetch(e.requestOptions));
          }
          return handler.next(e);
        },
      ),
    );
    return dio;
  }
}
