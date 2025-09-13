part of 'create_job_bloc.dart';

sealed class CreateJobEvent extends Equatable {
  const CreateJobEvent();

  @override
  List<Object> get props => [];
}

class CreateNewRequest extends CreateJobEvent {
  final JobRequestModel jobRequestModel;

  const CreateNewRequest({required this.jobRequestModel});
}

class UploadNewFile extends CreateJobEvent {
  final UploadFileRequest file;
  const UploadNewFile({required this.file});
}
