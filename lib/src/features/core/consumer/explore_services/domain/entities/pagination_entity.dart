class PaginationEntity {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  PaginationEntity({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });
}
