class CreateJobRouteModel {
  final String merchantId;
  final String serviceId;
  final String categoryId;
  final String lat;
  final String long;

  CreateJobRouteModel({
    required this.merchantId,
    required this.serviceId,
    required this.categoryId,
    required this.lat,
    required this.long,
  });
}
