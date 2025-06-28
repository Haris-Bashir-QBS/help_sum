import 'dart:developer';

import 'package:help_sum/src/core/extensions/dio_extensions.dart';
import 'package:help_sum/src/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:help_sum/src/features/auth/data/models/request/signup_request_model.dart';
import 'package:help_sum/src/features/auth/data/models/response/login_response_model.dart';
import 'package:help_sum/src/features/auth/data/models/response/signup_response_model.dart';

import '../../../../../core/constants/app_errors.dart';
import '../../../../../core/errors/api_exceptions.dart';
import '../../../../../core/network/client/dio_client.dart';
import '../../../../../core/network/config/api_endpoints.dart';
import '../../../../../core/network/config/error_handler.dart';

import '../../models/request/login_request_model.dart';
import '../../models/response/user_model.dart';

class AuthRemoteDataSourceImplementation implements AuthRemoteDataSource {
  final DioClient _client;

  AuthRemoteDataSourceImplementation({required DioClient client})
    : _client = client;

  @override
  Future<UserModel> login({required LoginRequestModel params}) async {
    return await ApiErrorHandler.executeGuarded(() async {
      final response = await _client.post(
        endpoint: ApiEndpoints.login.value,
        data: params.toJson(),
      );
      log("Response: ${response.data}");
      if (response.isOk) {
        UserModel user =
            LoginResponseModel.fromJson(response.data).data!.userDetail!;
        return user;
      } else {
        throw ServerException(
          statusCode: response.statusCode,
          message: response.data['message'] ?? AppErrors.somethingWentWrong,
        );
      }
    });
  }

  @override
  Future<String> signup({required SignUpRequestModel params}) async {
    return await ApiErrorHandler.executeGuarded(() async {
      final response = await _client.post(
        endpoint: ApiEndpoints.signup.value,
        data: params,
      );
      log("Response: ${response.data}");
      if (response.isCreated) {
        final String id = SignupResponseModel.fromJson(response.data).data!.id!;

        return id;
      } else {
        throw ServerException(
          statusCode: response.statusCode,
          message: response.data['message'] ?? AppErrors.somethingWentWrong,
        );
      }
    });
  }
}
