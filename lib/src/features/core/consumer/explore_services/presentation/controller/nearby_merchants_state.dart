import 'package:help_sum/src/features/core/consumer/explore_services/data/models/response/merchant_response_model.dart';

abstract class NearbyMerchantsState {}

class NearbyMerchantsInitial extends NearbyMerchantsState {}

class NearbyMerchantsLoading extends NearbyMerchantsState {}

class NearbyMerchantsLoaded extends NearbyMerchantsState {
  final List<MerchantModel> merchants;
  final int totalCount;
  final bool hasMore;

  NearbyMerchantsLoaded({
    required this.merchants,
    required this.totalCount,
    required this.hasMore,
  });
}

class NearbyMerchantsError extends NearbyMerchantsState {
  final String message;
  NearbyMerchantsError(this.message);
}
