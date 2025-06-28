import 'package:help_sum/src/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    super.id,
    super.role,
    super.image,
    super.firstName,
    super.lastName,
    super.email,
    super.phone,
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
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] as String?,
      role: json['role'] as String?,
      image: json['image']?.toString(),
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      email: json['email']?.toString(),
      phone: json['phone'] as String?,
      location:
          json['location'] != null
              ? LocationModel.fromJson(json['location'])
              : null,
      description: json['description']?.toString(),
      hourlyRate: json['hourlyRate'] as int?,
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

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      city: json['city']?.toString(),
      state: json['state']?.toString(),
      address: json['address']?.toString(),
      type: json['type'] as String?,
      coordinates:
          (json['coordinates'] as List?)?.map((e) => e as int).toList(),
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
