import 'package:help_sum/src/features/auth/data/models/request/schdule_request_model.dart';
import 'package:help_sum/src/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    super.id,
    super.role,
    super.image,
    super.firstName,
    super.lastName,
    super.email,
    super.rating,
    super.phone,
    super.totalJobsCompleted,
    super.location,
    super.description,
    super.hourlyRate,
    super.status,
    super.idCard,
    super.media,
    super.isConsumer,
    super.isMerchant,
    super.isNotification,
    super.isVerified,
    super.isCompleted,
    super.isDeleted,
    super.isBlocked,
    super.services,
    super.schedule,
    super.averageRating,
    super.totalReviews,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] as String?,
      role: json['role'] as String?,
      image: json['image']?.toString(),
      rating: json['rating'],
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      email: json['email']?.toString(),
      totalReviews: json['totalReviews']?.toString(),
      averageRating: json['averageRating']?.toString(),
      phone: json['phone'] as String?,
      location:
          json['location'] != null
              ? LocationModel.fromJson(json['location'])
              : null,
      description: json['description']?.toString(),
      hourlyRate:
          json['hourlyRate'] is int
              ? json['hourlyRate'] as int
              : int.tryParse(json['hourlyRate']?.toString() ?? '0'),
      status: json['status'] as bool?,
      idCard: json['idCard']?.toString(),
      media: (json['Media'] as List?)?.map((e) => e.toString()).toList(),
      isConsumer: json['isConsumer'] as bool?,
      isMerchant: json['isMerchant'] as bool?,
      isNotification: json['isNotification'] as bool?,
      isVerified: json['isVerified'] as bool?,
      isCompleted: json['isCompleted'] as bool?,
      isDeleted: json['isDeleted'] as bool?,
      isBlocked: json['isBlocked'] as bool?,
      services:
          (json['services'] as List?)
              ?.map((e) {
                if (e is String) {
                  return {'_id': e};
                } else if (e is Map<String, dynamic>) {
                  return Map<String, dynamic>.from(e);
                }
                return null;
              })
              .whereType<Map<String, dynamic>>()
              .toList(),
      schedule:
          (json['schedule'] as List?)
              ?.map((e) => Schedule.fromJson(e as Map<String, dynamic>))
              .toList(),
      totalJobsCompleted: json['totalCompletedJobs']?.toString(),
    );
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      role: entity.role,
      image: entity.image,
      firstName: entity.firstName,
      lastName: entity.lastName,
      email: entity.email,
      phone: entity.phone,
      location:
          entity.location != null
              ? LocationModel.fromEntity(entity.location!)
              : null,
      description: entity.description,
      hourlyRate: entity.hourlyRate,
      status: entity.status,
      rating: entity.rating,
      idCard: entity.idCard,
      media: entity.media,
      isConsumer: entity.isConsumer,
      isMerchant: entity.isMerchant,
      isNotification: entity.isNotification,
      isVerified: entity.isVerified,
      isCompleted: entity.isCompleted,
      isDeleted: entity.isDeleted,
      isBlocked: entity.isBlocked,
      services: entity.services,
      schedule: entity.schedule,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'role': role,
    'image': image,
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'phone': phone,
    'location': (location as LocationModel?)?.toJson(),
    'description': description,
    'hourlyRate': hourlyRate,
    'status': status,
    'idCard': idCard,
    'Media': media,
    'isConsumer': isConsumer,
    'isMerchant': isMerchant,
    'isNotification': isNotification,
    'isVerified': isVerified,
    'isCompleted': isCompleted,
    'isDeleted': isDeleted,
    'isBlocked': isBlocked,
    'services': services,
    'schedule': schedule?.map((e) => e.toJson()).toList(),
  };
}

class LocationModel extends LocationEntity {
  const LocationModel({
    super.city,
    super.state,
    super.address,
    super.type,
    super.coordinates,
  });
  factory LocationModel.fromEntity(LocationEntity entity) {
    return LocationModel(
      city: entity.city,
      state: entity.state,
      address: entity.address,
      type: entity.type,
      coordinates: entity.coordinates,
    );
  }

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      city: json['city']?.toString(),
      state: json['state']?.toString(),
      address: json['address']?.toString(),
      type: json['type']?.toString(),
      coordinates:
          (json['coordinates'] as List?)
              ?.map((e) => e is int ? e : int.tryParse(e.toString()) ?? 0)
              .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'city': city,
    'state': state,
    'address': address,
    'type': type,
    'coordinates': coordinates,
  };
}
