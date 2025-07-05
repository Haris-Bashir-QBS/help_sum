import 'package:help_sum/src/features/core/consumer/explore_services/domain/entities/category_entity.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/domain/entities/categories_response_entity.dart';

abstract class CategoryState {}

class GetCategoriesInitial extends CategoryState {}

class GetCategoriesLoading extends CategoryState {
  GetCategoriesLoading();
}

class GetCategoriesLoaded extends CategoryState {
  final List<CategoryEntity> categories;
  final bool hasMore;
  final int totalCount;
  final CategoriesResponseEntity response;

  GetCategoriesLoaded({
    required this.categories,
    required this.hasMore,
    required this.totalCount,
    required this.response,
  });
}

class GetCategoriesError extends CategoryState {
  final String message;
  final List<CategoryEntity> categories;
  final bool hasMore;
  final int totalCount;

  GetCategoriesError({
    required this.message,
    this.categories = const [],
    this.hasMore = false,
    this.totalCount = 0,
  });
}
