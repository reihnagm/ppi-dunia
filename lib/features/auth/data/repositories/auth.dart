import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:ppidunia/features/auth/data/models/user.dart';
import 'package:ppidunia/common/errors/exceptions.dart';
import 'package:ppidunia/features/country/data/models/country.dart';
import 'package:ppidunia/common/utils/dio.dart';
import 'package:ppidunia/common/consts/api_const.dart';

class AuthRepo {
  Dio? dioClient;

  AuthRepo({required this.dioClient}) {
    dioClient ??= DioManager.shared.getClient();
  }

  Future<UserModel> login(
      {required String email, required String password}) async {
    try {
      Response res = await dioClient!
          .post("${ApiConsts.baseUrl}/api/v1/auth/login", data: {
        "email": email,
        "password": password,
      });
      Map<String, dynamic> dataJson = res.data;
      UserModel data = UserModel.fromJson(dataJson);
      return data;
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioException(e).toString();
      throw CustomException(errorMessage);
    } catch (e, stacktrace) {
      debugPrint(e.toString());
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<UserModel> register(
      {required String email,
      required String password,
      required String firstName,
      required String lastName}) async {
    try {
      Response res = await dioClient!
          .post("${ApiConsts.baseUrl}/api/v1/auth/register", data: {
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "password": password,
      });
      Map<String, dynamic> dataJson = res.data;
      UserModel data = UserModel.fromJson(dataJson);
      return data;
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioException(e).toString();
      throw CustomException(errorMessage);
    } catch (e, stacktrace) {
      debugPrint(e.toString());
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<void> changePassword({
    required String email,
    required String newPassword,
    required String oldPassword,
  }) async {
    try {
      await dioClient!
          .post("${ApiConsts.baseUrl}/api/v1/auth/change-password", data: {
        "email": email,
        "old_password": oldPassword,
        "new_password": newPassword,
      });
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioException(e).toString();
      throw CustomException(errorMessage);
    } catch (e, stacktrace) {
      debugPrint(e.toString());
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<void> forgetPassword({required String email}) async {
    try {
      await dioClient!
          .post("${ApiConsts.baseUrl}/api/v1/auth/forgot-password", data: {
        "email": email,
      });
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioException(e).toString();
      throw CustomException(errorMessage);
    } catch (e, stacktrace) {
      debugPrint(e.toString());
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<void> updateEmail({
    required String oldEmail,
    required String newEmail,
  }) async {
    try {
      await dioClient!
          .post("${ApiConsts.baseUrl}/api/v1/auth/update-email", data: {
        "old_email": oldEmail,
        "new_email": newEmail,
      });
    } on DioException catch (e) {
      debugPrint(e.toString());
      final errorMessage = DioExceptions.fromDioException(e).toString();
      throw CustomException(errorMessage);
    } catch (e, stacktrace) {
      debugPrint(e.toString());
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<void> signInSocialMedia({
    required String email,
  }) async {
    try {
      await dioClient!
          .post("${ApiConsts.baseUrl}/api/v1/auth/social-media", data: {
        "email": email,
      });
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioException(e).toString();
      throw CustomException(errorMessage);
    } catch (e, stacktrace) {
      debugPrint(e.toString());
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<void> deleteAccount({
    required String userId,
  }) async {
    try {
      await dioClient!.post("${ApiConsts.baseUrl}/api/v1/auth/delete", data: {
        "user_id": userId,
      });
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioException(e).toString();
      throw CustomException(errorMessage);
    } catch (e, stacktrace) {
      debugPrint(e.toString());
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<UserModel> verifyOTP({
    required String email,
    required String otp,
  }) async {
    try {
      Response res = await dioClient!
          .post("${ApiConsts.baseUrl}/api/v1/auth/verify-otp", data: {
        "email": email,
        "otp": otp,
      });
      Map<String, dynamic> dataJson = res.data;
      UserModel data = UserModel.fromJson(dataJson);
      return data;
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioException(e).toString();
      throw CustomException(errorMessage);
    } catch (e, stacktrace) {
      debugPrint(e.toString());
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<void> resendOTP({
    required String email,
  }) async {
    try {
      await dioClient!
          .post("${ApiConsts.baseUrl}/api/v1/auth/resend-otp", data: {
        "email": email,
      });
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioException(e).toString();
      throw CustomException(errorMessage);
    } catch (e, stacktrace) {
      debugPrint(e.toString());
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<CountryModel> getCountries(
      {required int page, String search = ""}) async {
    try {
      Response res = await dioClient!
          .get("${ApiConsts.baseUrl}/api/v1/country", queryParameters: {
        "page": page,
        "limit": 10,
        "search": search,
      });
      Map<String, dynamic> dataJson = res.data;
      CountryModel data = CountryModel.fromJson(dataJson);
      return data;
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioException(e).toString();
      throw CustomException(errorMessage);
    } catch (e, stacktrace) {
      debugPrint(e.toString());
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }

  Future<void> assignCountry({required Object data}) async {
    try {
      await dioClient!.post(
        "${ApiConsts.baseUrl}/api/v1/country/assign",
        data: data,
      );
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioException(e).toString();
      throw CustomException(errorMessage);
    } catch (e, stacktrace) {
      debugPrint(e.toString());
      debugPrint(stacktrace.toString());
      throw CustomException(e.toString());
    }
  }
}
