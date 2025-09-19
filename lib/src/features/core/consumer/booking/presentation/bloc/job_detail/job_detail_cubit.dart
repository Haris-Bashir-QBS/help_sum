import 'package:bloc/bloc.dart';
import 'package:help_sum/src/features/core/consumer/booking/data/models/job_response_model.dart';
import 'package:help_sum/src/features/core/consumer/booking/domain/usecases/get_job_by_id_usecase.dart';
part 'job_detail_state.dart';

class JobDetailCubit extends Cubit<JobDetailState> {
  final GetJobByIdUseCase getJobByIdUseCase;

  JobDetailCubit(this.getJobByIdUseCase) : super(JobDetailInitial());

  Future<void> fetchJobDetail(String jobId) async {
    emit(JobDetailLoading());
    final result = await getJobByIdUseCase(jobId);

    result.fold(
      (failure) => emit(JobDetailError(failure.message)),
      (job) => emit(JobDetailLoaded(job)),
    );
  }
}
