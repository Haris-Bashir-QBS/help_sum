import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:help_sum/src/core/dependency_injection/di_barrel.dart';
import 'package:help_sum/src/features/core/consumer/booking/data/models/job_response_model.dart';
import 'package:help_sum/src/features/core/consumer/booking/domain/usecases/fetch_jobs_by_type_usecase.dart';

final allBookingsProvider = StateNotifierProvider.family<
  AllBookingsNotifier,
  AsyncValue<JobResponseModel>,
  String
>((ref, type) => AllBookingsNotifier(sl(), type));

final fetchJobsByTypeUseCaseProvider = Provider<FetchJobsByTypeUseCase>((ref) {
  return sl<FetchJobsByTypeUseCase>();
});

class AllBookingsNotifier extends StateNotifier<AsyncValue<JobResponseModel>> {
  final FetchJobsByTypeUseCase fetchJobsByTypeUseCase;
  final String type;

  AllBookingsNotifier(this.fetchJobsByTypeUseCase, this.type)
    : super(const AsyncLoading()) {
    fetchJobs();
  }

  Future<void> fetchJobs() async {
    state = const AsyncLoading();
    final result = await fetchJobsByTypeUseCase(type);
    result.fold(
      (failure) => state = AsyncError(failure.message, StackTrace.current),
      (data) => state = AsyncData(data),
    );
  }
}
