import 'package:fpdart/fpdart.dart';
import 'package:help_sum/src/core/errors/api_exceptions.dart';
import 'package:help_sum/src/features/core/common/profile/domain/entities/rating_entity.dart';

abstract interface class ProfileRepository {
  Future<Either<Failure, RatingResponseEntity>> getMerchantRatings({
    required String merchantId,
  });
}
