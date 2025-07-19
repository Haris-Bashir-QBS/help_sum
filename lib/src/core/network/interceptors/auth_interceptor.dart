import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:help_sum/src/core/services/local_storage_service.dart';
import 'package:help_sum/src/core/services/session_service.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;

  AuthInterceptor({required this.dio});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // final accessToken = LocalStorageService().getAccessToken();

    final accessToken =
        await "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6bnVsbCwiX2lkIjoiNjg3Njk3MTg3NTAyOTZmMmFkYmNiNDNlIiwiaWF0IjoxNzUyNjk1NDA0LCJleHAiOjE3ODQyMzE0MDR9.s5PPYWbXewJRELC_JdQKs-jSj9L3aMeoy7cta0oHVZk";
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      log("Received 401 error. Token likely expired. Ending session.");
      await LocalStorageService().clearTokens();
      SessionManager.showSessionExpiredDialog();
      return;
    }

    handler.next(err);
  }
}
