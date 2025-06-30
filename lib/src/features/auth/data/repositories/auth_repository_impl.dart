import 'package:fpdart/fpdart.dart';
import 'package:help_sum/src/features/auth/data/models/request/otp_request_model.dart';
import 'package:help_sum/src/features/auth/data/models/request/signup_request_model.dart';
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
  Future<Either<Failure, UserEntity>> login({
    required LoginRequestModel params,
  }) async {
    try {
      final UserModel user = await remoteDataSource.login(params: params);
      return right(user);
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
  Future<Either<Failure, UserEntity>> verifyOtp({
    required OtpRequestModel params,
  }) async {
    try {
      final UserModel user = await remoteDataSource.verifyOtp(params: params);
      return right(user);
    } on Failure catch (e) {
      return left(Failure(message: e.message));
    }
  }
}
