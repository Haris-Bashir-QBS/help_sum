part of 'job_details_bloc.dart';

abstract class JobDetailsEvent extends Equatable {
  const JobDetailsEvent();

  @override
  List<Object?> get props => [];
}

class StartJobEvent extends JobDetailsEvent {
  final String jobId;
  const StartJobEvent(this.jobId);

  @override
  List<Object?> get props => [jobId];
}

class CompleteJobEvent extends JobDetailsEvent {
  final String jobId;
  const CompleteJobEvent(this.jobId);

  @override
  List<Object?> get props => [jobId];
}

class ChangeJobStatusEvent extends JobDetailsEvent {
  final String jobId;
  final String action;
  final double? newHours;
  final double? newOffer;
  const ChangeJobStatusEvent({
    required this.jobId,
    required this.action,
    this.newHours,
    this.newOffer,
  });

  @override
  List<Object?> get props => [jobId, action, newHours, newOffer];
}

class ResetJobDetailsEvent extends JobDetailsEvent {}
