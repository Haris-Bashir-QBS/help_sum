import 'package:help_sum/src/features/core/consumer/explore_services/data/models/response/services_response_model.dart';

abstract class ServicesState {}

class GetServicesInitial extends ServicesState {}

class GetServicesLoading extends ServicesState {}

class GetServicesLoaded extends ServicesState {
  final ServicesResponseModel response;
  final List<ServiceModel> services;
  final bool hasMore;
  final int totalCount;

  GetServicesLoaded({
    required this.response,
    required this.services,
    required this.hasMore,
    required this.totalCount,
  });
}

class GetServicesError extends ServicesState {
  final String message;

  GetServicesError(this.message);
}
