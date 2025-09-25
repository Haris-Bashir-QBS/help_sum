import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:help_sum/src/features/core/consumer/booking/data/models/job_response_model.dart';
import 'package:help_sum/src/features/core/merchant/domain/params/update_job_params.dart';
import 'package:help_sum/src/features/core/merchant/domain/usecases/complete_job_usecase.dart';
import 'package:help_sum/src/features/core/merchant/domain/usecases/start_job_usecase.dart';
import 'package:help_sum/src/features/core/merchant/domain/usecases/update_job_status_merchant.dart';

part 'job_details_event.dart';
part 'job_details_state.dart';

class JobDetailsBloc extends Bloc<JobDetailsEvent, JobDetailsState> {
  final StartJobUseCase startJobUseCase;
  final CompleteJobUseCase completeJobUseCase;
  final UpdateJobStatusMerchantUseCase updateJobStatusMerchantUseCase;

  JobDetailsBloc({
    required this.startJobUseCase,
    required this.completeJobUseCase,
    required this.updateJobStatusMerchantUseCase,
  }) : super(JobDetailsInitial()) {
    on<StartJobEvent>(_onStartJob);
    on<CompleteJobEvent>(_onCompleteJob);
    on<ChangeJobStatusEvent>(_onChangeJobStatus);
    on<ResetJobDetailsEvent>((event, emit) => emit(JobDetailsInitial()));
  }

  Future<void> _onStartJob(
      StartJobEvent event, Emitter<JobDetailsState> emit) async {
    emit(JobDetailsLoading('start'));
    final result = await startJobUseCase(event.jobId);
    result.match(
      (failure) => emit(JobDetailsError(failure.message, 'start')),
      (jobData) => emit(JobActionSuccess('start', jobData)),
    );
  }

  Future<void> _onCompleteJob(
      CompleteJobEvent event, Emitter<JobDetailsState> emit) async {
    emit(JobDetailsLoading('complete'));
    final result = await completeJobUseCase(event.jobId);
    result.match(
      (failure) => emit(JobDetailsError(failure.message, 'complete')),
      (jobData) => emit(JobActionSuccess('complete', jobData)),
    );
  }

  Future<void> _onChangeJobStatus(
      ChangeJobStatusEvent event, Emitter<JobDetailsState> emit) async {
    emit(JobDetailsLoading(event.action));
    final params = UpdateJobParams(
      jobId: event.jobId,
      action: event.action,
      newHours: event.newHours,
      newOffer: event.newOffer,
    );
    final result = await updateJobStatusMerchantUseCase(params);
    result.match(
      (failure) => emit(JobDetailsError(failure.message, event.action)),
      (jobData) => emit(JobActionSuccess(event.action, jobData)),
    );
  }
}
