import 'package:help_sum/src/features/core/consumer/explore_services/domain/entities/service_provider_model.dart';

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
