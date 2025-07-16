import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/domain/usecases/get_services_by_category_usecase.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/domain/usecases/get_services_params.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/presentation/controller/services_state.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/data/models/response/services_response_model.dart';
import 'package:help_sum/src/features/core/merchant/domain/params/merchant_by_type_param.dart';
import 'package:help_sum/src/features/core/merchant/domain/usecases/fetch_jobs_by_type_merchant.dart';
import 'package:help_sum/src/features/core/merchant/presentation/controller/job_request_states.dart';

class MerchantJobsNotifier extends StateNotifier<MerchantJobsState> {
  final GetAllJobsByTypeUseCase _getServicesByCategoryUseCase;

  MerchantJobsNotifier(this._getServicesByCategoryUseCase)
    : super(MerchantJobsInitial());

  int _currentPage = 1;
  final List<ServiceModel> _services = [];
  String? _currentCategoryId;

  Future<void> getAllJobsByType({
    // required String categoryId,
    bool refresh = false,
    int? page,
    int? limit,
  }) async {
    final currentState = state;

    if (currentState is MerchantJobsLoading) return;

    // if (refresh || _currentCategoryId != categoryId) {
    //   _currentPage = 1;
    //   _services.clear();
    //   _currentCategoryId = categoryId;
    //   state = MerchantJobsLoading();
    // }

    // Don't fetch if no more data
    final isLoadedWithNoMore =
        currentState is MerchantJobsLoaded && !currentState.hasMore;

    if (isLoadedWithNoMore && !refresh) {
      return;
    }

    final params = MerchantByTypeParam(
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
        // _services.addAll(response.data.data);
        // final pagination = response.data.pagination;
        // final hasMore = pagination.page < pagination.totalPages;
        // _currentPage = pagination.page + 1;

        // state = MerchantJobsLoaded(
        //   response: response,
        //   hasMore: hasMore,
        //   totalCount: pagination.total,
        // );
      },
    );
  }

  void reset() {
    state = MerchantJobsInitial();
    _currentPage = 1;
    _services.clear();
    _currentCategoryId = null;
  }
}
