import 'package:fpdart/fpdart.dart';
import 'package:help_sum/src/features/auth/data/models/request/otp_request_model.dart';
import 'package:help_sum/src/features/auth/data/models/request/resend_otp_request_model.dart';
import 'package:help_sum/src/features/auth/data/models/request/signup_request_model.dart';
import 'package:help_sum/src/features/auth/data/models/request/update_profile_request_model.dart';
import 'package:help_sum/src/features/auth/data/models/request/upload_file_request_model.dart';
import 'package:help_sum/src/features/auth/data/models/response/services_groupped_model.dart';
import 'package:help_sum/src/features/auth/data/models/response/upload_file_response.dart';
import 'package:help_sum/src/features/auth/domain/entities/merchant_setup_respose_entitiy.dart';
import 'package:help_sum/src/features/auth/domain/repositories/auth_repository.dart';

import '../../../../core/errors/api_exceptions.dart';
import '../../domain/entities/user_entity.dart';
import '../datasources/remote/auth_remote_datasource.dart';
import '../models/request/login_request_model.dart';
import '../models/response/user_model.dart';

class AuthRepositoryImplementation implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImplementation({required this.remoteDataSource});

  @override
  Future<Either<Failure, (UserEntity, String)>> login({
    required LoginRequestModel params,
  }) async {
    try {
      final (user, token) = await remoteDataSource.login(params: params);
      return right((user, token));
    } on Failure catch (e) {
      return left(Failure(message: e.message));
    }
  }

  // Fro signup
  @override
  Future<Either<Failure, String>> signup({
    required SignUpRequestModel params,
  }) async {
    try {
      final String userId = await remoteDataSource.signup(params: params);
      return right(userId);
    } on Failure catch (e) {
      return left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<UploadedFileEntity>>> uploadFile({
    required UploadFileRequest params,
  }) async {
    try {
      final files = await remoteDataSource.uploadFile(params: params);
      return right(files);
    } on Failure catch (e) {
      return left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, (UserEntity, String)>> verifyOtp({
    required OtpRequestModel params,
  }) async {
    try {
      final (user, token) = await remoteDataSource.verifyOtp(params: params);
      return right((user, token));
    } on Failure catch (e) {
      return left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, String>> resendOtp({
    required ResendOtpRequestModel params,
  }) async {
    try {
      final String message = await remoteDataSource.resendOtp(params: params);
      return right(message);
    } on Failure catch (e) {
      return left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateProfile({
    required UpdateProfileRequest params,
  }) async {
    try {
      final UserEntity user = await remoteDataSource.updateProfile(
        params: params,
      );
      return right(user);
    } on Failure catch (e) {
      return left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<GroupedCategoryModel>>> getServices() async {
    try {
      final categories = await remoteDataSource.getGroupedServices();
      return right(categories);
    } on Failure catch (e) {
      return left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, MerchantSetupResposeEntitiy>>
  getMerchantSetupDetails() async {
    try {
      final categories = await remoteDataSource.getMerchantSetupDetails();
      return right(categories);
    } on Failure catch (e) {
      return left(Failure(message: e.message));
    }
  }
}
