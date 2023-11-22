import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';

import 'test_helper.mocks.dart';

class MockDioHelper {
  static MockDio getClient() {
    MockDio mockDioClient = MockDio();
    when(mockDioClient.options).thenAnswer((_) {
      mockDioClient.options.headers = {
        "Authorization": "Bearer a",
      };
      return mockDioClient.options;
    });
    return mockDioClient;
  }

  static DioAdapter getDioAdapter(String baseUrl, MockDio dio) {
    return DioAdapter(
      dio: dio,
      matcher: const FullHttpRequestMatcher(),
    );
  }

  static Response getSuccessResponse({required String path,required Map<String, dynamic> data}) {
    return Response(
      data: data,
      requestOptions: RequestOptions(path: path),
      statusCode: 200,
    );
  }

  // static MockDioException getInternalServerError({required String path}) {
  //   return MockDioException(
  //     requestOptions: RequestOptions(path: path),
  //     response: Response(
  //       statusCode: 400,
  //       requestOptions: RequestOptions(path: path),
  //       data: {
  //         "message": "Some beautiful error",
  //       },
  //     ),
  //     type: DioExceptionType.badResponse,
  //   );
  // }

  // static MockDioException getOtherError({required String path}) {
  //   return MockDioException(
  //     requestOptions: RequestOptions(path: path),
  //     type: DioExceptionType.unknown,
  //   );
  // }
}
