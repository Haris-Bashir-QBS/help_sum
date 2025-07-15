import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:help_sum/src/core/dependency_injection/di_barrel.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/domain/entities/service_provider_model.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/domain/usecases/get_merchant_view_profile_usecase.dart';

class MerchantViewProfileState {
  const MerchantViewProfileState();
}

class MerchantViewProfileInitial extends MerchantViewProfileState {}

class MerchantViewProfileLoading extends MerchantViewProfileState {}

class MerchantViewProfileLoaded extends MerchantViewProfileState {
  final ServiceProviderModel profile;
  MerchantViewProfileLoaded(this.profile);
}

class MerchantViewProfileError extends MerchantViewProfileState {
  final String message;
  MerchantViewProfileError({required this.message});
}

class MerchantViewProfileNotifier
    extends StateNotifier<MerchantViewProfileState> {
  final GetMerchantViewProfileUseCase useCase;
  MerchantViewProfileNotifier(this.useCase)
    : super(MerchantViewProfileInitial());

  Future<void> fetchProfile(String merchantId) async {
    state = MerchantViewProfileLoading();
    try {
      final profile = await useCase(merchantId);
      state = MerchantViewProfileLoaded(profile);
    } catch (e) {
      state = MerchantViewProfileError(message: e.toString());
    }
  }
}

final merchantViewProfileProvider = StateNotifierProvider.family<
  MerchantViewProfileNotifier,
  MerchantViewProfileState,
  String
>((ref, merchantId) {
  return MerchantViewProfileNotifier(getMerchantViewProfileUseCase);
});
