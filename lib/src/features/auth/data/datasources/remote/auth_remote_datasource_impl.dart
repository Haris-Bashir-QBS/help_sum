import 'dart:developer';

import 'package:help_sum/src/core/extensions/dio_extensions.dart';
import 'package:help_sum/src/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:help_sum/src/features/auth/data/models/request/otp_request_model.dart';
import 'package:help_sum/src/features/auth/data/models/request/resend_otp_request_model.dart';
import 'package:help_sum/src/features/auth/data/models/request/signup_request_model.dart';
import 'package:help_sum/src/features/auth/data/models/request/update_profile_request_model.dart';
import 'package:help_sum/src/features/auth/data/models/request/upload_file_request_model.dart';
import 'package:help_sum/src/features/auth/data/models/response/login_response_model.dart';
import 'package:help_sum/src/features/auth/data/models/response/services_groupped_model.dart';
import 'package:help_sum/src/features/auth/data/models/response/signup_response_model.dart';
import 'package:help_sum/src/features/auth/data/models/response/upload_file_response.dart';
import 'package:help_sum/src/features/auth/domain/entities/user_entity.dart';

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
  Future<(UserModel, String)> login({required LoginRequestModel params}) async {
    return await ApiErrorHandler.executeGuarded(() async {
      final response = await _client.post(
        endpoint: ApiEndpoints.login.value,
        data: params.toJson(),
      );
      log("Response: ${response.data}");
      if (response.isOk) {
        final loginResponse = LoginResponseModel.fromJson(response.data);
        UserModel user = loginResponse.data!.userDetail!;
        String token = loginResponse.data!.token!;
        return (user, token);
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

  @override
  Future<UserModel> verifyOtp({required OtpRequestModel params}) async {
    return await ApiErrorHandler.executeGuarded(() async {
      final response = await _client.post(
        endpoint: ApiEndpoints.verifyOtp.value,
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
  Future<String> resendOtp({required ResendOtpRequestModel params}) async {
    return await ApiErrorHandler.executeGuarded(() async {
      final response = await _client.post(
        endpoint: ApiEndpoints.resendCode.value,
        data: params.toJson(),
      );
      if (response.isOk) {
        return response.data['message'] ?? "";
      } else {
        throw ServerException(
          statusCode: response.statusCode,
          message: response.data['message'] ?? AppErrors.somethingWentWrong,
        );
      }
    });
  }

  @override
  Future<UserEntity> updateProfile({
    required UpdateProfileRequest params,
  }) async {
    return await ApiErrorHandler.executeGuarded(() async {
      final response = await _client.put(
        endpoint: ApiEndpoints.updateProfile.value,
        data: params.toJson(),
      );
      log("Response: ${response.data}");
      if (response.isOk) {
        UserModel user = UserModel.fromJson(response.data['data']);
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
  Future<List<UploadedFileModel>> uploadFile({
    required UploadFileRequest params,
  }) async {
    return await ApiErrorHandler.executeGuarded(() async {
      // final formData = FormData.fromMap(params.toFormData());
      final response = await _client.post(
        endpoint: ApiEndpoints.uploadFile.value,
        data: params.toFormData(),
      );
      log("Response: ${response.data}");
      if (response.isOk) {
        if (response.data['files'] != null) {
          return (response.data['files'] as List)
              .map((e) => UploadedFileModel.fromJson(e))
              .toList();
        }
        return [];
      } else {
        throw ServerException(
          statusCode: response.statusCode,
          message: response.data['message'] ?? AppErrors.somethingWentWrong,
        );
      }
    });
  }

  @override
  Future<List<GroupedCategoryModel>> getGroupedServices() async {
    return await ApiErrorHandler.executeGuarded(() async {
      final response = await _client.get(
        endpoint: ApiEndpoints.serviceGrouped.value,
      );

      if (response.isOk) {
        final data = response.data['data']['data'] as List<dynamic>? ?? [];
        return data.map((e) => GroupedCategoryModel.fromJson(e)).toList();
      } else {
        throw ServerException(
          statusCode: response.statusCode,
          message: response.data['message'] ?? AppErrors.somethingWentWrong,
        );
      }
    });
  }
}
