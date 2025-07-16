class BookingRequestModel {
  final double lat;
  final double long;
  final int? page;
  final int? limit;
  final String? serviceId;

  BookingRequestModel({
    this.page,
    this.limit,
    required this.lat,
    required this.long,
    this.serviceId,
  });

  Map<String, dynamic> toJson() => {
    'lat': lat,
    'long': long,
    if (serviceId != null) 'serviceId': serviceId,
  };
}
