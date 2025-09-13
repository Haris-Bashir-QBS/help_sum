import 'package:equatable/equatable.dart';

class RatingResponseEntity extends Equatable {
  final bool status;
  final int code;
  final List<RatingEntity> data;
  final String message;

  const RatingResponseEntity({
    required this.status,
    required this.code,
    required this.data,
    required this.message,
  });

  @override
  List<Object?> get props => [status, code, data, message];
}

class RatingEntity extends Equatable {
  final List<String> images;
  final String id;
  final ConsumerEntity consumerId;
  final String merchantId;
  final String jobId;
  final int rating;
  final String review;
  final String byRole;
  final bool isSubmitted;
  final String createdAt;
  final String updatedAt;
  final int v;

  const RatingEntity({
    required this.images,
    required this.id,
    required this.consumerId,
    required this.merchantId,
    required this.jobId,
    required this.rating,
    required this.review,
    required this.byRole,
    required this.isSubmitted,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  @override
  List<Object?> get props => [
        images,
        id,
        consumerId,
        merchantId,
        jobId,
        rating,
        review,
        byRole,
        isSubmitted,
        createdAt,
        updatedAt,
        v,
      ];
}

class ConsumerEntity extends Equatable {
  final LocationEntity? location;
  final String id;
  final String? image;
  final String firstName;
  final String lastName;
  final String? phone;
  final String? description;

  const ConsumerEntity({
    this.location,
    required this.id,
    this.image,
    required this.firstName,
    required this.lastName,
    this.phone,
    this.description,
  });

  @override
  List<Object?> get props => [
        location,
        id,
        image,
        firstName,
        lastName,
        phone,
        description,
      ];
}

class LocationEntity extends Equatable {
  final String? city;
  final String? state;
  final String? address;
  final String type;
  final List<double> coordinates;

  const LocationEntity({
    this.city,
    this.state,
    this.address,
    required this.type,
    required this.coordinates,
  });

  @override
  List<Object?> get props => [city, state, address, type, coordinates];
}
