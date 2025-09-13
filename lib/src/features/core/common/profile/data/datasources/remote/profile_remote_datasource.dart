import 'package:help_sum/src/features/core/common/profile/domain/entities/rating_entity.dart';

abstract interface class ProfileRemoteDataSource {
  Future<RatingResponseEntity> getMerchantRatings({required String merchantId});
  Future<void> deleteAccount();
}