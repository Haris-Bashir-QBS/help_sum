import 'package:help_sum/src/core/models/common/paginated_model.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/data/models/response/category_model.dart';

class GetCategoriesResponseModel {
  final bool status;
  final int code;
  final String message;
  final GetCategoriesDataModel data;

  GetCategoriesResponseModel({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  factory GetCategoriesResponseModel.fromJson(Map<String, dynamic> json) {
    return GetCategoriesResponseModel(
      status: json['status'] ?? false,
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: GetCategoriesDataModel.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'code': code,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class GetCategoriesDataModel {
  final List<CategoryModel> categories;
  final PaginationModel pagination;

  GetCategoriesDataModel({required this.categories, required this.pagination});

  factory GetCategoriesDataModel.fromJson(Map<String, dynamic> json) {
    return GetCategoriesDataModel(
      categories:
          (json['data'] as List<dynamic>?)
              ?.map((item) => CategoryModel.fromJson(item))
              .toList() ??
          [],
      pagination: PaginationModel.fromJson(json['pagination'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': categories.map((category) => category.toJson()).toList(),
      'pagination': pagination.toJson(),
    };
  }

  bool get hasMore => pagination.page < pagination.totalPages;
  int get totalCount => pagination.total;
}
