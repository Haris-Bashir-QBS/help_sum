part of 'create_job_bloc.dart';

abstract class CreateJobState extends Equatable {}

class CreateJobInitial extends CreateJobState {
  @override
  List<Object?> get props => [];
}

class CreateJobLoading extends CreateJobState {
  @override
  List<Object?> get props => [];
}

class UploadFileLoading extends CreateJobState {
  @override
  List<Object?> get props => [];
}

class UploadFileError extends CreateJobState {
  final String message;
  UploadFileError({required this.message});
  @override
  List<Object?> get props => [message];
}

class CreateJobSuccess extends CreateJobState {
  final JobResponseModel response;
  CreateJobSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class CreateJobError extends CreateJobState {
  final String message;
  CreateJobError(this.message);

  @override
  List<Object?> get props => [message];
}

class UploadFileSuccess extends CreateJobState {
  final List<UploadedFileEntity> files;
  UploadFileSuccess({required this.files});

  @override
  List<Object?> get props => [files];
}
