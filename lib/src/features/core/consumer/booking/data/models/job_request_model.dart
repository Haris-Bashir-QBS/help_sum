class JobRequestModel {
  final String merchantId;
  final String serviceId;
  final String title;
  final String description;
  final String address;
  final String city;
  final String state;
  final String lat;
  final String long;
  final String date;
  final String time;
  final int estimatedWorkTime;
  final String offer;
  final List<String> media;

  JobRequestModel({
    required this.merchantId,
    required this.serviceId,
    required this.title,
    required this.description,
    required this.address,
    required this.city,
    required this.state,
    required this.lat,
    required this.long,
    required this.date,
    required this.time,
    required this.estimatedWorkTime,
    required this.offer,
    required this.media,
  });

  Map<String, dynamic> toJson() => {
    'merchantId': merchantId,
    'serviceId': serviceId,
    'title': title,
    'description': description,
    'address': address,
    'city': city,
    'state': state,
    'lat': lat,
    'long': long,
    'date': date,
    'time': time,
    'estimatedWorkTime': estimatedWorkTime,
    'offer': offer,
    'media': media,
  };
}
