import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:help_sum/src/core/errors/api_exceptions.dart';
import 'package:help_sum/src/core/errors/dio_exception_mapper.dart';

class ApiErrorHandler {
  static Future<T> executeGuarded<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on DioException catch (e) {
      throw DioExceptionMapper.mapDioExceptionToFailure(e);
    } on SocketException catch (e) {
      throw NetworkException();
    } on FormatException catch (e) {
      throw ParsingException(message: 'Invalid JSON: ${e.message}');
    } catch (e) {
      throw UnknownException(message: 'Unexpected error: $e');
    }
  }
}
