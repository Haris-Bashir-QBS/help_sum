// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:help_sum/src/features/auth/data/models/request/schdule_request_model.dart';

class UserEntity {
  final String? id;
  final String? role;
  final String? image;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final LocationEntity? location;
  final String? description;
  final int? hourlyRate;
  final bool? status;
  final String? idCard;
  final List<String>? media;
  final String? rating;
  final bool? isConsumer;
  final bool? isMerchant;
  final bool? isNotification;
  final bool? isVerified;
  bool? isCompleted;
  final bool? isDeleted;
  final bool? isBlocked;

  // ✅ Add missing fields here
  final List<Map<String, dynamic>>? services;
  final List<Schedule>? schedule;

  UserEntity({
    this.id,
    this.role,
    this.image,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.location,
    this.description,
    this.hourlyRate,
    this.status,
    this.idCard,
    this.media,
    this.isConsumer,
    this.isMerchant,
    this.isNotification,
    this.isVerified,
    this.isCompleted,
    this.isDeleted,
    this.isBlocked,
    this.services,
    this.rating,
    this.schedule,
  });

  UserEntity copyWith({
    String? id,
    String? role,
    String? image,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    LocationEntity? location,
    String? description,
    int? hourlyRate,
    bool? status,
    String? idCard,
    List<String>? media,
    bool? isConsumer,
    bool? isMerchant,
    bool? isNotification,
    bool? isVerified,
    bool? isCompleted,
    bool? isDeleted,
    String? rating,
    bool? isBlocked,
    List<Map<String, dynamic>>? services,
    List<Schedule>? schedule,
  }) {
    return UserEntity(
      id: id ?? this.id,
      role: role ?? this.role,
      image: image ?? this.image,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      description: description ?? this.description,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      status: status ?? this.status,
      idCard: idCard ?? this.idCard,
      media: media ?? this.media,
      isConsumer: isConsumer ?? this.isConsumer,
      isMerchant: isMerchant ?? this.isMerchant,
      isNotification: isNotification ?? this.isNotification,
      isVerified: isVerified ?? this.isVerified,
      isCompleted: isCompleted ?? this.isCompleted,
      isDeleted: isDeleted ?? this.isDeleted,
      isBlocked: isBlocked ?? this.isBlocked,
      services: services ?? this.services,
      schedule: schedule ?? this.schedule,
      rating: rating ?? this.rating,
    );
  }
}

class LocationEntity {
  final String? city;
  final String? state;
  final String? address;
  final String? type;
  final List<int>? coordinates;

  const LocationEntity({
    this.city,
    this.state,
    this.address,
    this.type,
    this.coordinates,
  });

  LocationEntity copyWith({
    String? city,
    String? state,
    String? address,
    String? type,
    List<int>? coordinates,
  }) {
    return LocationEntity(
      city: city ?? this.city,
      state: state ?? this.state,
      address: address ?? this.address,
      type: type ?? this.type,
      coordinates: coordinates ?? this.coordinates,
    );
  }
}
