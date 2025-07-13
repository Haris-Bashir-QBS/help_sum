import 'package:dio/dio.dart';

extension DioResponseExtension on Response {
  bool get isOk => statusCode == 200;
  bool get isCreated => statusCode == 201;
}
