import 'schdule_request_model.dart';

class UpdateProfileRequest {
  final String? city;
  final String? state;
  final String? address;
  final double? lat;
  final double? long;
  final String? description;
  final String? phone;
  final String? firstName;
  final String? email;
  final String? lastName;
  final String? image;
  final int? hourlyRate;
  final List<String>? services;
  final String? idCard;
  final List<String>? media;
  final List<Schedule>? schedule;

  UpdateProfileRequest({
    this.city,
    this.state,
    this.address,
    this.lat,
    this.long,
    this.email,
    this.description,
    this.phone,
    this.firstName,
    this.lastName,
    this.image,
    this.hourlyRate,
    this.services,
    this.idCard,
    this.media,
    this.schedule,
  });
}

extension UserProfileSerializer on UpdateProfileRequest {
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    void add(String key, dynamic value) {
      if (value != null && (!(value is List) || value.isNotEmpty)) {
        data[key] = value;
      }
    }

    add('city', city);
    add('email', email);
    add('state', state);
    add('address', address);
    add('phone', phone);
    add('lat', lat);
    add('long', long);
    add('description', description);
    add('firstName', firstName);
    add('lastName', lastName);
    add('image', image);
    add('hourlyRate', hourlyRate);
    add('services', services);
    add('idCard', idCard);
    add('Media', media);

    add('schedule', schedule?.map((s) => s.toJson()).toList());

    return data;
  }
}
