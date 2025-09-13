import 'package:fpdart/fpdart.dart';
import 'package:help_sum/src/core/errors/api_exceptions.dart';
import 'package:help_sum/src/core/use_cases/use_case.dart';
import 'package:help_sum/src/features/core/common/profile/domain/entities/rating_entity.dart';
import 'package:help_sum/src/features/core/common/profile/domain/repositories/profile_repository.dart';

class GetMerchantRatingsParams {
  final String merchantId;

  GetMerchantRatingsParams({required this.merchantId});
}

class GetMerchantRatingsUseCase extends UseCase<RatingResponseEntity, GetMerchantRatingsParams> {
  final ProfileRepository _profileRepository;

  GetMerchantRatingsUseCase({required ProfileRepository profileRepository})
      : _profileRepository = profileRepository;

  @override
  Future<Either<Failure, RatingResponseEntity>> call(GetMerchantRatingsParams params) async {
    return await _profileRepository.getMerchantRatings(
      merchantId: params.merchantId,
    );
  }
}
