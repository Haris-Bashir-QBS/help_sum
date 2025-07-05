import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/domain/entities/category_entity.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/domain/usecases/get_categories_usecase.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/presentation/controller/category_providers.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/presentation/controller/category_state.dart';
import 'package:help_sum/src/core/dependency_injection/di_barrel.dart';

class CategoryNotifier extends AsyncNotifier<CategoryState> {
  late final GetCategoriesUseCase _getCategoriesUseCase = sl();
  int _currentPage = 1;
  List<CategoryEntity> _categories = [];

  @override
  Future<CategoryState> build() async => GetCategoriesInitial();

  Future<void> fetchCategories({bool refresh = false}) async {
    final currentState = state.value;
    List<CategoryEntity> currentItems = [];

    if ((currentState is GetCategoriesLoaded &&
            !currentState.hasMore &&
            refresh != true) ||
        currentState is GetCategoriesLoading) {
      print("");
      print("Inside returnnnn");
      return;
    }

    if (refresh == true) {
      print("here it issss");
      _currentPage = 1;
      _categories = [];
      state = AsyncValue.data(GetCategoriesLoading());
    } else {
      currentItems = List.from(_categories);
    }

    final params = GetCategoriesParams(page: _currentPage, limit: 20);

    final result = await _getCategoriesUseCase(params);

    result.fold(
      (failure) {
        state = AsyncValue.data(
          GetCategoriesError(
            message: failure.message,
            categories: currentItems,
            hasMore: false,
            totalCount: currentItems.length,
          ),
        );
      },
      (response) {
        final List<CategoryEntity> newList = [
          ...currentItems,
          ...response.data.categories,
        ];

        final hasMore = newList.length < response.data.totalCount;
        _categories = newList;
        _currentPage = response.data.pagination.page + 1;

        state = AsyncValue.data(
          GetCategoriesLoaded(
            categories: newList,
            hasMore: hasMore,
            totalCount: response.data.totalCount,
            response: response,
          ),
        );
      },
    );
  }
}
