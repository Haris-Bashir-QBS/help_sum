part of 'job_detail_cubit.dart';

sealed class JobDetailState {}

class JobDetailInitial extends JobDetailState {}

class JobDetailLoading extends JobDetailState {}

class JobDetailLoaded extends JobDetailState {
  final JobData job;
  JobDetailLoaded(this.job);
}

class JobDetailError extends JobDetailState {
  final String message;
  JobDetailError(this.message);
}
