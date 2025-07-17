import 'package:help_sum/src/features/core/merchant/domain/entities/merchant_job_request_resposne_entity.dart';

abstract class MerchantJobsState {}

class MerchantJobsInitial extends MerchantJobsState {}

class MerchantJobsLoading extends MerchantJobsState {}

class MerchantJobsLoaded extends MerchantJobsState {
  final MerchantJobRequestsEntity response;
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
