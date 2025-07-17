import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:help_sum/src/features/core/merchant/domain/entities/merchant_job_request_resposne_entity.dart';
import 'package:help_sum/src/features/core/merchant/domain/params/merchant_by_type_param.dart';
import 'package:help_sum/src/features/core/merchant/domain/usecases/fetch_jobs_by_type_merchant.dart';
import 'package:help_sum/src/features/core/merchant/presentation/controller/job_request_states.dart';

class MerchantJobsNotifier extends StateNotifier<MerchantJobsState> {
  final GetAllJobsByTypeUseCase _getServicesByCategoryUseCase;

  MerchantJobsNotifier(this._getServicesByCategoryUseCase)
    : super(MerchantJobsInitial());

  int _currentPage = 1;
  List<JobRequestEntity> allJobs = [];

  Future<void> getAllJobsByType({
    // required String categoryId,
    required String jobType,
    bool refresh = false,
    int? page,
    int? limit,
  }) async {
    print("JJJ $state");
    final currentState = state;

    print(currentState is MerchantJobsLoading);

    if (currentState is MerchantJobsLoading) return;

    if (refresh) {
      _currentPage = 1;
      allJobs.clear();
      state = MerchantJobsLoading();
    }

    // Don't fetch if no more data
    final isLoadedWithNoMore =
        currentState is MerchantJobsLoaded && !currentState.hasMore;

    if (isLoadedWithNoMore && !refresh) {
      return;
    }

    final params = MerchantByTypeParam(
      jobType,
      // categoryId: categoryId,
      // page: page ?? _currentPage,
      // limit: limit ?? 10,
    );

    final result = await _getServicesByCategoryUseCase(params);

    result.match(
      (failure) {
        state = MerchantJobsError(failure.message);
      },
      (response) {
        allJobs.addAll(response.data?.data ?? []);
        final pagination = response.data?.pagination;
        final hasMore = (pagination?.page ?? 0) < (pagination?.totalPages ?? 0);
        _currentPage = (pagination?.page ?? 0) + 1;

        state = MerchantJobsLoaded(
          response: response,
          hasMore: hasMore,
          totalCount: pagination?.total ?? 0,
        );
      },
    );
  }

  void reset() {
    state = MerchantJobsInitial();
    _currentPage = 1;
    allJobs.clear();
  }
}
