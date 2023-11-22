import 'package:ppidunia/data/models/news/news.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:ppidunia/data/repository/news/news.dart';
import 'package:ppidunia/utils/constant.dart';
import '../../../helpers/dio_test_helper.dart';
import '../../../helpers/test_helper.mocks.dart';
import '../../dummy_data/news/mock_news.dart';

//TODO: implement ke semua repository, dibikin unit testnya :)
///    referensinya bisa cek:
/// - https://youtu.be/xS1D6Aw_w-w
/// - https://docs.flutter.dev/cookbook/testing/unit/introduction
/// - https://blog.logrocket.com/unit-testing-flutter-code-mockito/
/// - https://www.toptal.com/flutter/unit-testing-flutter
/// - https://sahasuthpala.medium.com/unit-testing-in-dio-dart-package-91b7a78314bc

/// dan yang terpenting, selalu bikin test case pertama itu hasil ekspektasinya itu error/salah dulu
/// baru nanti lanjut ke ekspektasinya sukses/bener.

/// satu lagi ini referensi yang gak kalah penting: 
/// - https://medium.com/flutter-community/unit-testing-business-components-in-flutter-apps-27c5d35e4102

/// biar lebih jelas kenapa ada "act", "assert", dan "arrange"
void main() {
  const String path = "${AppConstants.baseUrl}/api/v1/news";
  late DioAdapter mockDioAdapter;
  late MockDio mockDioClient;
  late NewsRepo dataSource;

  setUpAll(() async {
    mockDioClient = MockDioHelper.getClient();
    mockDioAdapter = MockDioHelper.getDioAdapter(path, mockDioClient);
    when(mockDioClient.httpClientAdapter)
        .thenAnswer((_) => mockDioClient.httpClientAdapter = mockDioAdapter);
    dataSource = NewsRepo(dioClient: mockDioClient);
  });

  group('News Api Test (repository)', () {
    test('Should throw internal server error when fetch process is failed',
        () async {
      //arrange
      // final dioError = MockDioHelper.getInternalServerError(path: path);
      // when(mockDioClient.get(path)).thenThrow(dioError);

      //act
      final call = dataSource.getNews();

      //assert
      expect(call, throwsException);
    });

    test('Should throw DioExceptionType.other when fetch process is failed',
        () async {
      //arrange
      // final dioError = MockDioHelper.getOtherError(path: path);
      // when(mockDioClient.get(path)).thenThrow(dioError);

      //act
      final call = dataSource.getNews();

      //assert
      expect(call, throwsException);
    });

    test(
      'Should returns a Future<NewsModel?> when fetch process is success',
      () {
        //arrange
        final mockResponseData = MockNews.expectedResponseModel;
        final responseBody = MockDioHelper.getSuccessResponse(path: path, data: mockResponseData);
        when(mockDioClient.get(path)).thenAnswer((_) async => responseBody);

        //act
        final call = dataSource.getNews();

        //assert
        expect(call, isA<Future<NewsModel?>>());
      },
    );
  });

  //TODO: ini contoh testing post method, bisa cek repo hp3ki di folder test/repository/upgrade_member
  // group("Contoh Post Method", () { 
  //   const diffPath = path+'/inquiry';
  //   const String paymentCode = "999";

  //   test('Should throw internal server error when fetch process is failed',
  //     () async {
  //     //arrange
  //     final dioError = MockDioHelper.getInternalServerError(path: diffPath);
  //     when(mockDioClient.post( diffPath, data: anyNamed('data'),
  //     )).thenThrow(dioError);

  //     //act
  //     final call = dataSource.sendPaymentInquiry(userId: mockUID, paymentCode: paymentCode);

  //     //assert
  //     expect(call, throwsException);
  //   });

  //   test('Should throw DioExceptionType.other when fetch process is failed',
  //       () async {
  //     //arrange
  //     final dioError = MockDioHelper.getOtherError(path: diffPath);
  //     when(mockDioClient.post(diffPath, data: anyNamed('data'),
  //     )).thenThrow(dioError);

  //     //act
  //     final call = dataSource.sendPaymentInquiry(userId: mockUID, paymentCode: paymentCode);

  //     //assert
  //     expect(call, throwsException);
  //   });

  //   test(
  //     'Should returns a Future<InquiryModel?> when fetch process is success',
  //     () {
  //       //arrange
  //       final mockResponseData = MockInquiry.expectedResponseModel;
  //       final responseBody = Response(
  //         data: mockResponseData,
  //         requestOptions: RequestOptions(path: diffPath),
  //         statusCode: 200,
  //       );
  //       when(mockDioClient.post(diffPath, data: anyNamed('data'),
  //       )).thenAnswer((_) async => responseBody);

  //       //act
  //       final call = dataSource.sendPaymentInquiry(userId: mockUID, paymentCode: paymentCode);

  //       //assert
  //       expect(call, isA<Future<InquiryModel?>>());
  //     },
  //   );
  // });
}
