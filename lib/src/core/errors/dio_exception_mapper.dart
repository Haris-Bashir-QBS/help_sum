import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:help_sum/src/core/constants/app_errors.dart';
import 'package:help_sum/src/core/errors/api_exceptions.dart';

class DioExceptionMapper {
  static Failure mapDioExceptionToFailure(DioException error) {
    log("Type is ${error.type}");
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.connectionError:
        return NetworkException(requestOptions: error.requestOptions);
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return ServerException(
          message: AppErrors.timeoutTryAgain,
          requestOptions: error.requestOptions,
          response: error.response,
        );
      case DioExceptionType.badResponse:
        return ServerException(
          message: _extractErrorMessage(error),
          requestOptions: error.requestOptions,
          response: error.response,
        );
      default:
        return UnknownException(
          requestOptions: error.requestOptions,
          message: _extractErrorMessage(error),
        );
    }
  }
}

String _extractErrorMessage(DioException error) {
  final data = error.response?.data;
  if (data is Map<String, dynamic> && data.containsKey("message")) {
    return "${data["message"]}";
  }
  return "${error.response?.statusMessage ?? error.error}";
}
