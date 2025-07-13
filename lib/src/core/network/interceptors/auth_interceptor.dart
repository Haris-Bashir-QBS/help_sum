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
    final accessToken = LocalStorageService().getAccessToken();
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
