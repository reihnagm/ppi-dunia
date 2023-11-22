import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ppidunia/localization/language_constraints.dart';
import 'package:ppidunia/utils/color_resources.dart';
import 'package:ppidunia/views/basewidgets/snackbar/snackbar.dart';

class DioExceptions implements Exception {
  late String message;

DioExceptions.fromDioException(DioException dioError) {
  switch (dioError.type) {
    case DioExceptionType.cancel:
      message = "Request to API server was cancelled";
      break;
    case DioExceptionType.connectionTimeout:
      message = "Connection timeout with API server";
      break;
    case DioExceptionType.receiveTimeout:
      message = "Receive timeout in connection with API server";
      break;
    case DioExceptionType.badResponse:
      message = _handleError(
        dioError.response?.statusCode,
        dioError.response?.data,
      );
      break;
    case DioExceptionType.sendTimeout:
      message = "Send timeout in connection with API server";
      break;
    case DioExceptionType.unknown:
      if (dioError.message?.contains("SocketException") == true) {
        message = 'No Internet';
        break;
      }
      message = "Unexpected error occurred";
      break;
    default:
      message = "Something went wrong";
      break;
  }
}

  String _handleError(int? statusCode, dynamic error) {
    String errorMsg = error["message"];
    switch (statusCode) {
      case 400:
        return errorMsg;
      case 401:
        return 'Unauthorized';
      case 403:
        return 'Forbidden';
      case 404:
        return errorMsg;
      case 500:
        return 'Internal server error';
      case 502:
        return 'Bad gateway';
      default:
        return 'Oops something went wrong';
    }
  }

  @override
  String toString() => message;
}


class CustomException implements Exception {
  final dynamic cause;
  CustomException([this.cause]);

  @override
  String toString() {
    Object? cause = this.cause;
    if (cause == null) return "CustomException";
    return cause.toString();
  }
}

class NetworkException{
  static void handle(BuildContext context, String e) {
    if(e.contains('Internet')) {
      ShowSnackbar.snackbar(
        context,
        getTranslated('NO_INTERNET'),
        '',
        ColorResources.black,
        const Duration(seconds: 6),
      );
    }
  }
}