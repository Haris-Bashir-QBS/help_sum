import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:help_sum/src/core/network/config/api_base.dart';
import 'package:help_sum/src/core/network/interceptors/auth_interceptor.dart';
import 'package:help_sum/src/core/network/interceptors/connectivity_intereceptor.dart';
import 'package:help_sum/src/core/network/interceptors/logger_interceptor.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  late Dio _dio;

  factory DioClient() => _instance;

  DioClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiBase.baseUrl,
        connectTimeout: const Duration(seconds: 40),
        receiveTimeout: const Duration(seconds: 40),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      ),
    );
    // Chuck chuck = Chuck(
    //   showNotification: true,
    //   navigatorKey: SessionManager.navigatorKey,
    //   darkTheme: true,
    // );
    _dio.interceptors.addAll([
      ConnectivityInterceptor(),
      AuthInterceptor(dio: _dio),
      if (kDebugMode) LoggerInterceptor(),

      // ChuckerDioInterceptor(),
    ]);
  }

  /// Set Base URL dynamically
  void setBaseUrl(String baseUrl) {
    _dio.options.baseUrl = baseUrl;
  }

  /// GET Request with Custom Base URL
  Future<Response> get({
    required String endpoint,
    String? customBaseUrl,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? customHeaders,
    Duration? timeout,
  }) async {
    return _dio.get(
      (customBaseUrl ?? _dio.options.baseUrl) + endpoint,
      queryParameters: queryParams,
    );
  }

  Future<Response> post({
    required String endpoint,
    String? customBaseUrl,
    Map<String, dynamic>? queryParams,
    dynamic data,
    Map<String, dynamic>? customHeaders,
    Duration? timeout,
  }) async {
    return _dio.post(
      (customBaseUrl ?? _dio.options.baseUrl) + endpoint,
      data: data,
      queryParameters: queryParams,
      options: _getOptions(customHeaders, timeout),
    );
  }

  Future<Response> put({
    required String endpoint,
    String? customBaseUrl,
    Map<String, dynamic>? queryParams,
    dynamic data,
    Map<String, dynamic>? customHeaders,
    Duration? timeout,
  }) async {
    return _dio.put(
      (customBaseUrl ?? _dio.options.baseUrl) + endpoint,
      data: data,
      queryParameters: queryParams,
      options: _getOptions(customHeaders, timeout),
    );
  }

  /// DELETE Request with Custom Base URL
  Future<Response> delete({
    required String endpoint,
    String? customBaseUrl,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? customHeaders,
    Duration? timeout,
  }) async {
    return _dio.delete(
      (customBaseUrl ?? _dio.options.baseUrl) + endpoint,
      options: _getOptions(customHeaders, timeout),
      queryParameters: queryParams,
    );
  }

  /// Get customized Dio options (headers & timeout)
  Options _getOptions(Map<String, dynamic>? customHeaders, Duration? timeout) {
    final options = Options();
    if (customHeaders != null) {
      options.headers = {..._dio.options.headers, ...customHeaders};
    }
    if (timeout != null) {
      _dio.options.connectTimeout = timeout;
      _dio.options.receiveTimeout = timeout;
    }
    return options;
  }
}
