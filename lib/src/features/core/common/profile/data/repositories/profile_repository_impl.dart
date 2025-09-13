import 'package:fpdart/fpdart.dart';
import 'package:help_sum/src/core/errors/api_exceptions.dart';
import 'package:help_sum/src/features/core/common/profile/data/datasources/remote/profile_remote_datasource.dart';
import 'package:help_sum/src/features/core/common/profile/domain/entities/rating_entity.dart';
import 'package:help_sum/src/features/core/common/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImplementation implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImplementation({required this.remoteDataSource});

  @override
  Future<Either<Failure, RatingResponseEntity>> getMerchantRatings({
    required String merchantId,
  }) async {
    try {
      final ratingResponse = await remoteDataSource.getMerchantRatings(
        merchantId: merchantId,
      );
      return right(ratingResponse);
    } on Failure catch (e) {
      return left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    try {
      await remoteDataSource.deleteAccount();
      return right(null);
    } on Failure catch (e) {
      return left(Failure(message: e.message));
    }
  }
}
