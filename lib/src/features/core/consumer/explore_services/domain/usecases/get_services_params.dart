class GetServicesParams {
  final String categoryId;
  final int? page;
  final int? limit;

  GetServicesParams({required this.categoryId, this.page, this.limit});

  factory GetServicesParams.withoutPagination({required String categoryId}) {
    return GetServicesParams(categoryId: categoryId);
  }

  factory GetServicesParams.withPagination({
    required String categoryId,
    required int page,
    required int limit,
  }) {
    return GetServicesParams(categoryId: categoryId, page: page, limit: limit);
  }
}
