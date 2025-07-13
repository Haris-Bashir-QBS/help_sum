// ignore_for_file: public_member_api_docs, sort_constructors_first
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
  final bool? isConsumer;
  final bool? isMerchant;
  final bool? isNotification;
  final bool? isVerified;
  bool? isCompleted;
  final bool? isDeleted;
  final bool? isBlocked;

  // ✅ Add missing fields here
  final List<Map<String, dynamic>>? services;
  final List<Map<String, dynamic>>? schedule;

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
    this.schedule,
  });

  @override
  String toString() {
    return 'UserEntity(id: $id, role: $role, image: $image, firstName: $firstName, lastName: $lastName, email: $email, phone: $phone, location: $location, description: $description, hourlyRate: $hourlyRate, status: $status, idCard: $idCard, media: $media, isConsumer: $isConsumer, isMerchant: $isMerchant, isNotification: $isNotification, isVerified: $isVerified, isCompleted: $isCompleted, isDeleted: $isDeleted, isBlocked: $isBlocked, services: $services, schedule: $schedule)';
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
}
