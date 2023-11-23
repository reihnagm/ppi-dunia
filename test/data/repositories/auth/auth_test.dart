// import 'package:mockito/mockito.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:http_mock_adapter/http_mock_adapter.dart';
// import 'package:ppidunia/data/models/auth/user.dart';
// import 'package:ppidunia/data/models/country/country.dart';
// import 'package:ppidunia/data/repository/auth/auth.dart';
// import 'package:ppidunia/utils/constant.dart';
// import '../../../helpers/dio_test_helper.dart';
// import '../../../helpers/test_helper.mocks.dart';
// import '../../dummy_data/auth/mock_user.dart';
// import '../../dummy_data/country/mock_country.dart';

// void main() {
//   const String any = "any";
//   const String path = "${ApiConsts.baseUrl}/api/v1/auth";
//   late DioAdapter mockDioAdapter;
//   late MockDio mockDioClient;
//   late AuthRepo dataSource;

//   setUpAll(() async {
//     mockDioClient = MockDioHelper.getClient();
//     mockDioAdapter = MockDioHelper.getDioAdapter(path, mockDioClient);
//     when(mockDioClient.httpClientAdapter)
//         .thenAnswer((_) => mockDioClient.httpClientAdapter = mockDioAdapter);
//     dataSource = AuthRepo(dioClient: mockDioClient);
//   });

//   group('Auth Api Test (repository)', () {
//     group('Login (post)', () {
//       const diffPath = path+'/login';

//       test('Should throw internal server error when process is failed',
//         () async {
//         //arrange
//         final dioError = MockDioHelper.getInternalServerError(path: diffPath);
//         when(mockDioClient.post( diffPath, data: anyNamed('data'),
//         )).thenThrow(dioError);

//         //act
//         final call = dataSource.login(email: any, password: any);

//         //assert
//         expect(call, throwsException);
//       });

//       test('Should throw DioErrorType.other when process is failed',
//           () async {
//         //arrange
//         final dioError = MockDioHelper.getOtherError(path: diffPath);
//         when(mockDioClient.post(diffPath, data: anyNamed('data'),
//         )).thenThrow(dioError);

//         //act
//         final call = dataSource.login(email: any, password: any);

//         //assert
//         expect(call, throwsException);
//       });

//       test(
//         'Should returns a Future<UserModel> when process is success',
//         () {
//           //arrange
//           final mockResponseData = MockUser.expectedResponseModel;
//           final responseBody = MockDioHelper.getSuccessResponse(path: path, data: mockResponseData);
//           when(mockDioClient.post(diffPath, data: anyNamed('data'),
//           )).thenAnswer((_) async => responseBody);

//           //act
//           final call = dataSource.login(email: any, password: any);

//           //assert
//           expect(call, isA<Future<UserModel>>());
//         },
//       );
//     });

//     group('Register (post)', () {
//       const diffPath = path+'/register';

//       test('Should throw internal server error when process is failed',
//         () async {
//         //arrange
//         final dioError = MockDioHelper.getInternalServerError(path: diffPath);
//         when(mockDioClient.post( diffPath, data: anyNamed('data'),
//         )).thenThrow(dioError);

//         //act
//         final call = dataSource.register(email: any, password: any, firstName: any, lastName: any,);

//         //assert
//         expect(call, throwsException);
//       });

//       test('Should throw DioErrorType.other when process is failed',
//           () async {
//         //arrange
//         final dioError = MockDioHelper.getOtherError(path: diffPath);
//         when(mockDioClient.post(diffPath, data: anyNamed('data'),
//         )).thenThrow(dioError);

//         //act
//         final call = dataSource.register(email: any, password: any, firstName: any, lastName: any,);

//         //assert
//         expect(call, throwsException);
//       });

//       test(
//         'Should returns a Future<UserModel> when process is success',
//         () {
//           //arrange
//           final mockResponseData = MockUser.expectedResponseModel;
//           final responseBody = MockDioHelper.getSuccessResponse(path: path, data: mockResponseData);
//           when(mockDioClient.post(diffPath, data: anyNamed('data'),
//           )).thenAnswer((_) async => responseBody);

//           //act
//           final call = dataSource.register(email: any, password: any, firstName: any, lastName: any,);

//           //assert
//           expect(call, isA<Future<UserModel>>());
//         },
//       );
//     });

//     group('Change Password (post)', () {
//       const diffPath = path+'/change-password';

//       test('Should throw internal server error when process is failed',
//         () async {
//         //arrange
//         final dioError = MockDioHelper.getInternalServerError(path: diffPath);
//         when(mockDioClient.post( diffPath, data: anyNamed('data'),
//         )).thenThrow(dioError);

//         //act
//         final call = dataSource.changePassword(email: any, newPassword: any, oldPassword: any,);

//         //assert
//         expect(call, throwsException);
//       });

//       test('Should throw DioErrorType.other when process is failed',
//           () async {
//         //arrange
//         final dioError = MockDioHelper.getOtherError(path: diffPath);
//         when(mockDioClient.post(diffPath, data: anyNamed('data'),
//         )).thenThrow(dioError);

//         //act
//         final call = dataSource.changePassword(email: any, newPassword: any, oldPassword: any,);

//         //assert
//         expect(call, throwsException);
//       });

//       test(
//         'Should returns a Future<void> when process is success',
//         () {
//           //arrange
//           final mockResponseData = MockUser.expectedResponseModel;
//           final responseBody = MockDioHelper.getSuccessResponse(path: path, data: mockResponseData);
//           when(mockDioClient.post(diffPath, data: anyNamed('data'),
//           )).thenAnswer((_) async => responseBody);

//           //act
//           final call = dataSource.changePassword(email: any, newPassword: any, oldPassword: any,);

//           //assert
//           expect(call, isA<Future<void>>());
//         },
//       );
//     });

//     group('Forget Password (post)', () {
//       const diffPath = path+'/forgot-password';

//       test('Should throw internal server error when process is failed',
//         () async {
//         //arrange
//         final dioError = MockDioHelper.getInternalServerError(path: diffPath);
//         when(mockDioClient.post( diffPath, data: anyNamed('data'),
//         )).thenThrow(dioError);

//         //act
//         final call = dataSource.forgetPassword(email: any);

//         //assert
//         expect(call, throwsException);
//       });

//       test('Should throw DioErrorType.other when process is failed',
//           () async {
//         //arrange
//         final dioError = MockDioHelper.getOtherError(path: diffPath);
//         when(mockDioClient.post(diffPath, data: anyNamed('data'),
//         )).thenThrow(dioError);

//         //act
//         final call = dataSource.forgetPassword(email: any);

//         //assert
//         expect(call, throwsException);
//       });

//       test(
//         'Should returns a Future<void> when process is success',
//         () {
//           //arrange
//           final mockResponseData = MockUser.expectedResponseModel;
//           final responseBody = MockDioHelper.getSuccessResponse(path: path, data: mockResponseData);
//           when(mockDioClient.post(diffPath, data: anyNamed('data'),
//           )).thenAnswer((_) async => responseBody);

//           //act
//           final call = dataSource.forgetPassword(email: any);

//           //assert
//           expect(call, isA<Future<void>>());
//         },
//       );
//     });

//     group('Update Email (post)', () {
//       const diffPath = path+'/update-email';

//       test('Should throw internal server error when process is failed',
//         () async {
//         //arrange
//         final dioError = MockDioHelper.getInternalServerError(path: diffPath);
//         when(mockDioClient.post( diffPath, data: anyNamed('data'),
//         )).thenThrow(dioError);

//         //act
//         final call = dataSource.updateEmail(oldEmail: any, newEmail: any);

//         //assert
//         expect(call, throwsException);
//       });

//       test('Should throw DioErrorType.other when process is failed',
//           () async {
//         //arrange
//         final dioError = MockDioHelper.getOtherError(path: diffPath);
//         when(mockDioClient.post(diffPath, data: anyNamed('data'),
//         )).thenThrow(dioError);

//         //act
//         final call = dataSource.updateEmail(oldEmail: any, newEmail: any);

//         //assert
//         expect(call, throwsException);
//       });

//       test(
//         'Should returns a Future<void> when process is success',
//         () {
//           //arrange
//           final mockResponseData = MockUser.expectedResponseModel;
//           final responseBody = MockDioHelper.getSuccessResponse(path: path, data: mockResponseData);
//           when(mockDioClient.post(diffPath, data: anyNamed('data'),
//           )).thenAnswer((_) async => responseBody);

//           //act
//           final call = dataSource.updateEmail(oldEmail: any, newEmail: any);

//           //assert
//           expect(call, isA<Future<void>>());
//         },
//       );
//     });

//     group('Sign In Social Media (post)', () {
//       const diffPath = path+'/social-media';

//       test('Should throw internal server error when process is failed',
//         () async {
//         //arrange
//         final dioError = MockDioHelper.getInternalServerError(path: diffPath);
//         when(mockDioClient.post( diffPath, data: anyNamed('data'),
//         )).thenThrow(dioError);

//         //act
//         final call = dataSource.signInSocialMedia(email: any,);

//         //assert
//         expect(call, throwsException);
//       });

//       test('Should throw DioErrorType.other when process is failed',
//           () async {
//         //arrange
//         final dioError = MockDioHelper.getOtherError(path: diffPath);
//         when(mockDioClient.post(diffPath, data: anyNamed('data'),
//         )).thenThrow(dioError);

//         //act
//         final call = dataSource.signInSocialMedia(email: any,);

//         //assert
//         expect(call, throwsException);
//       });

//       test(
//         'Should returns a Future<void> when process is success',
//         () {
//           //arrange
//           final mockResponseData = MockUser.expectedResponseModel;
//           final responseBody = MockDioHelper.getSuccessResponse(path: path, data: mockResponseData);
//           when(mockDioClient.post(diffPath, data: anyNamed('data'),
//           )).thenAnswer((_) async => responseBody);

//           //act
//           final call = dataSource.signInSocialMedia(email: any,);

//           //assert
//           expect(call, isA<Future<void>>());
//         },
//       );
//     });

//     group('Delete Account (post)', () {
//       const diffPath = path+'/delete';

//       test('Should throw internal server error when process is failed',
//         () async {
//         //arrange
//         final dioError = MockDioHelper.getInternalServerError(path: diffPath);
//         when(mockDioClient.post( diffPath, data: anyNamed('data'),
//         )).thenThrow(dioError);

//         //act
//         final call = dataSource.deleteAccount(userId: any);

//         //assert
//         expect(call, throwsException);
//       });

//       test('Should throw DioErrorType.other when process is failed',
//           () async {
//         //arrange
//         final dioError = MockDioHelper.getOtherError(path: diffPath);
//         when(mockDioClient.post(diffPath, data: anyNamed('data'),
//         )).thenThrow(dioError);

//         //act
//         final call = dataSource.deleteAccount(userId: any);

//         //assert
//         expect(call, throwsException);
//       });

//       test(
//         'Should returns a Future<void> when process is success',
//         () {
//           //arrange
//           final mockResponseData = MockUser.expectedResponseModel;
//           final responseBody = MockDioHelper.getSuccessResponse(path: path, data: mockResponseData);
//           when(mockDioClient.post(diffPath, data: anyNamed('data'),
//           )).thenAnswer((_) async => responseBody);

//           //act
//           final call = dataSource.deleteAccount(userId: any);

//           //assert
//           expect(call, isA<Future<void>>());
//         },
//       );
//     });

//     group('Verify OTP (post)', () {
//       const diffPath = path+'/verify-otp';

//       test('Should throw internal server error when process is failed',
//         () async {
//         //arrange
//         final dioError = MockDioHelper.getInternalServerError(path: diffPath);
//         when(mockDioClient.post( diffPath, data: anyNamed('data'),
//         )).thenThrow(dioError);

//         //act
//         final call = dataSource.verifyOTP(email: any, otp: any);

//         //assert
//         expect(call, throwsException);
//       });

//       test('Should throw DioErrorType.other when process is failed',
//           () async {
//         //arrange
//         final dioError = MockDioHelper.getOtherError(path: diffPath);
//         when(mockDioClient.post(diffPath, data: anyNamed('data'),
//         )).thenThrow(dioError);

//         //act
//         final call = dataSource.verifyOTP(email: any, otp: any);

//         //assert
//         expect(call, throwsException);
//       });

//       test(
//         'Should returns a Future<void> when process is success',
//         () {
//           //arrange
//           final mockResponseData = MockUser.expectedResponseModel;
//           final responseBody = MockDioHelper.getSuccessResponse(path: path, data: mockResponseData);
//           when(mockDioClient.post(diffPath, data: anyNamed('data'),
//           )).thenAnswer((_) async => responseBody);

//           //act
//           final call = dataSource.verifyOTP(email: any, otp: any);

//           //assert
//           expect(call, isA<Future<void>>());
//         },
//       );
//     });

//     group('Resend OTP (post)', () {
//       const diffPath = path+'/resend-otp';

//       test('Should throw internal server error when process is failed',
//         () async {
//         //arrange
//         final dioError = MockDioHelper.getInternalServerError(path: diffPath);
//         when(mockDioClient.post( diffPath, data: anyNamed('data'),
//         )).thenThrow(dioError);

//         //act
//         final call = dataSource.resendOTP(email: any);

//         //assert
//         expect(call, throwsException);
//       });

//       test('Should throw DioErrorType.other when process is failed',
//           () async {
//         //arrange
//         final dioError = MockDioHelper.getOtherError(path: diffPath);
//         when(mockDioClient.post(diffPath, data: anyNamed('data'),
//         )).thenThrow(dioError);

//         //act
//         final call = dataSource.resendOTP(email: any);

//         //assert
//         expect(call, throwsException);
//       });

//       test(
//         'Should returns a Future<void> when process is success',
//         () {
//           //arrange
//           final mockResponseData = MockUser.expectedResponseModel;
//           final responseBody = MockDioHelper.getSuccessResponse(path: path, data: mockResponseData);
//           when(mockDioClient.post(diffPath, data: anyNamed('data'),
//           )).thenAnswer((_) async => responseBody);

//           //act
//           final call = dataSource.resendOTP(email: any);

//           //assert
//           expect(call, isA<Future<void>>());
//         },
//       );
//     });

//     group('Get Countries (get)', () {
//       const diffPath = ApiConsts.baseUrl+'/api/v1/country';

//       test('Should throw internal server error when process is failed',
//         () async {
//         //arrange
//         final dioError = MockDioHelper.getInternalServerError(path: diffPath);
//         when(mockDioClient.get(diffPath, queryParameters: {
//           "page": any.length,
//           "limit": 10,
//           "search": "",
//         })).thenThrow(dioError);

//         //act
//         final call = dataSource.getCountries(page: any.length);

//         //assert
//         expect(call, throwsException);
//       });

//       test('Should throw DioErrorType.other when process is failed',
//           () async {
//         //arrange
//         final dioError = MockDioHelper.getOtherError(path: diffPath);
//         when(mockDioClient.get(diffPath, queryParameters: {
//           "page": any.length,
//           "limit": 10,
//           "search": "",
//         })).thenThrow(dioError);

//         //act
//         final call = dataSource.getCountries(page: any.length);

//         //assert
//         expect(call, throwsException);
//       });

//       test(
//         'Should returns a Future<CountryModel> when process is success',
//         () {
//           //arrange
//           final mockResponseData = MockCountry.expectedResponseModel;
//           final responseBody = MockDioHelper.getSuccessResponse(path: path, data: mockResponseData);
//           when(mockDioClient.get(diffPath, queryParameters: {
//             "page": any.length,
//             "limit": 10,
//             "search": "",
//           })).thenAnswer((_) async => responseBody);

//           //act
//           final call = dataSource.getCountries(page: any.length);

//           //assert
//           expect(call, isA<Future<CountryModel>>());
//         },
//       );
//     });

//     group('Assign Country (post)', () {
//       const diffPath = ApiConsts.baseUrl+'/api/v1/country/assign';
//       const Object data = {
//         "any": any,
//       };

//       test('Should throw internal server error when process is failed',
//         () async {
//         //arrange
//         final dioError = MockDioHelper.getInternalServerError(path: diffPath);
//         when(mockDioClient.post(diffPath, data: data)).thenThrow(dioError);

//         //act
//         final call = dataSource.assignCountry(data: data);

//         //assert
//         expect(call, throwsException);
//       });

//       test('Should throw DioErrorType.other when process is failed',
//           () async {
//         //arrange
//         final dioError = MockDioHelper.getOtherError(path: diffPath);
//         when(mockDioClient.post(diffPath, data: data)).thenThrow(dioError);

//         //act
//         final call = dataSource.assignCountry(data: data);

//         //assert
//         expect(call, throwsException);
//       });

//       test(
//         'Should returns a Future<void> when process is success',
//         () {
//           //arrange
//           final mockResponseData = MockCountry.expectedResponseModel;
//           final responseBody = MockDioHelper.getSuccessResponse(path: path, data: mockResponseData);
//           when(mockDioClient.post(diffPath, data: data)).thenAnswer((_) async => responseBody);

//           //act
//           final call = dataSource.assignCountry(data: data);

//           //assert
//           expect(call, isA<Future<void>>());
//         },
//       );
//     });
//   });
// }
