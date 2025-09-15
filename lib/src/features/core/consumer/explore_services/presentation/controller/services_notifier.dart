import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/data/models/response/services_response_model.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/domain/usecases/get_services_by_category_usecase.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/domain/usecases/get_services_params.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/presentation/controller/services_state.dart';

class ServicesNotifier extends StateNotifier<ServicesState> {
  final GetServicesByCategoryUseCase _getServicesByCategoryUseCase;

  ServicesNotifier(this._getServicesByCategoryUseCase)
    : super(GetServicesInitial());

  int _currentPage = 1;
  final List<ServiceModel> _services = [];
  String? _currentCategoryId;

  Future<void> getServicesByCategory({
    required String categoryId,
    bool refresh = false,
    int? page,
    int? limit,
  }) async {
    final currentState = state;

    if (currentState is GetServicesLoading) return;

    if (refresh || _currentCategoryId != categoryId) {
      _currentPage = 1;
      _services.clear();
      _currentCategoryId = categoryId;
      state = GetServicesLoading();
    }

    // Don't fetch if no more data
    final isLoadedWithNoMore =
        currentState is GetServicesLoaded && !currentState.hasMore;

    if (isLoadedWithNoMore && !refresh) {
      return;
    }

    final params = GetServicesParams(
      categoryId: categoryId,
      page: page ?? _currentPage,
      limit: limit ?? 10,
    );

    final result = await _getServicesByCategoryUseCase(params);

    result.match(
      (failure) {
        state = GetServicesError(failure.message);
      },
      (response) {
        _services.addAll(response.data.data);
        final pagination = response.data.pagination;
        final hasMore = pagination.page < pagination.totalPages;
        _currentPage = pagination.page + 1;

        state = GetServicesLoaded(
          response: response,
          services: List<ServiceModel>.from(_services),
          hasMore: hasMore,
          totalCount: pagination.total,
        );
      },
    );
  }

  void reset() {
    state = GetServicesInitial();
    _currentPage = 1;
    _services.clear();
    _currentCategoryId = null;
  }

  void clearServices() {
    state = GetServicesInitial();
    _services.clear();
  }
}
