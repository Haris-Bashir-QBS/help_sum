import 'package:help_sum/src/features/core/consumer/explore_services/domain/entities/category_entity.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/domain/entities/pagination_entity.dart';

class CategoriesResponseEntity {
  final bool status;
  final int code;
  final String message;
  final CategoriesDataEntity data;

  CategoriesResponseEntity({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });
}

class CategoriesDataEntity {
  final List<CategoryEntity> categories;
  final PaginationEntity pagination;

  CategoriesDataEntity({required this.categories, required this.pagination});

  bool get hasMore => pagination.page < pagination.totalPages;
  int get totalCount => pagination.total;
}
