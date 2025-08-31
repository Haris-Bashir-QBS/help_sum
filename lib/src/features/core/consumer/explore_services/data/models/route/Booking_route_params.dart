class BookingRouteParams {
  final String categoryId;
  final String serviceId;
  final String? categoryName;
  final String? serviceName;

  BookingRouteParams({
    this.categoryName,
    this.serviceName,
    required this.categoryId,
    required this.serviceId,
  });
}
