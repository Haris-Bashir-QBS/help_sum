import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/domain/usecases/get_merchant_view_profile_usecase.dart';
import 'merchant_view_profile_state.dart';

class MerchantViewProfileNotifier
    extends StateNotifier<MerchantViewProfileState> {
  final GetMerchantViewProfileUseCase gerMerchantProfileUseCase;
  MerchantViewProfileNotifier(this.gerMerchantProfileUseCase)
    : super(MerchantViewProfileInitial());

  Future<void> fetchProfile(String merchantId) async {
    state = MerchantViewProfileLoading();

    final params = GetMerchantViewProfileParams(merchantId: merchantId);
    final result = await gerMerchantProfileUseCase(params);

    result.fold(
      (failure) => state = MerchantViewProfileError(message: failure.message),
      (profile) => state = MerchantViewProfileLoaded(profile),
    );
  }
}
