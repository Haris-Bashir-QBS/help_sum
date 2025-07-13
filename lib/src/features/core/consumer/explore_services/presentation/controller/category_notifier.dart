import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/domain/entities/category_entity.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/domain/usecases/get_categories_usecase.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/domain/usecases/get_categories_params.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/presentation/controller/category_state.dart';

class CategoryNotifier extends StateNotifier<CategoryState> {
  final GetCategoriesUseCase _getCategoriesUseCase;

  CategoryNotifier(this._getCategoriesUseCase) : super(GetCategoriesInitial());

  int _currentPage = 1;
  final List<CategoryEntity> _categories = [];

  Future<void> fetchCategories({bool refresh = false}) async {
    final currentState = state;

    final isLoadedWithNoMore =
        currentState is GetCategoriesLoaded && !currentState.hasMore;

    if ((isLoadedWithNoMore && !refresh) ||
        currentState is GetCategoriesLoading) {
      return;
    }

    if (refresh) {
      _currentPage = 1;
      _categories.clear();
      state = GetCategoriesLoading();
    }

    final params = GetCategoriesParams(page: _currentPage, limit: 20);
    final result = await _getCategoriesUseCase(params);

    result.fold(
      (failure) {
        state = GetCategoriesError(message: failure.message);
      },
      (response) {
        _categories.addAll(response.data.categories);
        final hasMore = _categories.length < response.data.totalCount;
        _currentPage = response.data.pagination.page + 1;
        state = GetCategoriesLoaded(
          categories: List<CategoryEntity>.from(_categories),
          hasMore: hasMore,
          totalCount: response.data.totalCount,
        );
      },
    );
  }
}
