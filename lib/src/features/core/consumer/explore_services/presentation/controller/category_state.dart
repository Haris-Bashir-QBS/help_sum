import 'package:help_sum/src/features/core/consumer/explore_services/domain/entities/category_entity.dart';

abstract class CategoryState {}

class GetCategoriesInitial extends CategoryState {}

class GetCategoriesLoading extends CategoryState {
  GetCategoriesLoading();
}

class GetCategoriesLoaded extends CategoryState {
  final List<CategoryEntity> categories;
  final bool hasMore;
  final int totalCount;

  GetCategoriesLoaded({
    required this.categories,
    required this.hasMore,
    required this.totalCount,
  });
}

class GetCategoriesError extends CategoryState {
  final String message;

  GetCategoriesError({required this.message});
}
