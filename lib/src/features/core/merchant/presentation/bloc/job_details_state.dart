part of 'job_details_bloc.dart';

abstract class JobDetailsState extends Equatable {
  const JobDetailsState();

  @override
  List<Object?> get props => [];
}

class JobDetailsInitial extends JobDetailsState {}

class JobDetailsLoading extends JobDetailsState {
  final String? action;
  const JobDetailsLoading([this.action]);

  @override
  List<Object?> get props => [action];
}

class JobDetailsLoaded extends JobDetailsState {
  final JobResponseModel response;
  final bool hasMore;
  final int totalCount;
  const JobDetailsLoaded({
    required this.response,
    required this.hasMore,
    required this.totalCount,
  });

  @override
  List<Object?> get props => [response, hasMore, totalCount];
}

class JobDetailsError extends JobDetailsState {
  final String message;
  final String? action;
  const JobDetailsError(this.message, [this.action]);

  @override
  List<Object?> get props => [message, action];
}

class JobActionSuccess extends JobDetailsState {
  final String action;
  final JobData jobData;
  const JobActionSuccess(this.action, this.jobData);

  @override
  List<Object?> get props => [action, jobData];
}
