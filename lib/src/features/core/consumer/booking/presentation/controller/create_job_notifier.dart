import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:help_sum/src/features/core/consumer/booking/data/models/job_request_model.dart';
import 'package:help_sum/src/features/core/consumer/booking/data/models/job_response_model.dart';
import 'package:help_sum/src/features/core/consumer/booking/domain/usecases/create_job_usecase.dart';

abstract class CreateJobState {}

class CreateJobInitial extends CreateJobState {}

class CreateJobLoading extends CreateJobState {}

class CreateJobSuccess extends CreateJobState {
  final JobResponseModel response;
  CreateJobSuccess(this.response);
}

class CreateJobError extends CreateJobState {
  final String message;
  CreateJobError(this.message);
}

class CreateJobNotifier extends StateNotifier<CreateJobState> {
  final CreateJobUseCase _createJobUseCase;
  CreateJobNotifier(this._createJobUseCase) : super(CreateJobInitial());

  Future<void> createJob(JobRequestModel params) async {
    state = CreateJobLoading();
    final result = await _createJobUseCase(params);
    result.match(
      (failure) => state = CreateJobError(failure.message),
      (response) => state = CreateJobSuccess(response),
    );
  }
}
