import 'package:help_sum/src/features/core/consumer/explore_services/data/models/response/services_response_model.dart';

abstract class MerchantJobsState {}

class MerchantJobsInitial extends MerchantJobsState {}

class MerchantJobsLoading extends MerchantJobsState {}

class MerchantJobsLoaded extends MerchantJobsState {
  final ServicesResponseModel response;
  final bool hasMore;
  final int totalCount;

  MerchantJobsLoaded({
    required this.response,
    required this.hasMore,
    required this.totalCount,
  });
}

class MerchantJobsError extends MerchantJobsState {
  final String message;

  MerchantJobsError(this.message);
}
