import 'package:help_sum/src/features/core/common/profile/domain/entities/rating_entity.dart';

class RatingResponseModel {
  final bool status;
  final int code;
  final List<RatingModel> data;
  final String message;

  const RatingResponseModel({
    required this.status,
    required this.code,
    required this.data,
    required this.message,
  });

  factory RatingResponseModel.fromJson(Map<String, dynamic> json) {
    return RatingResponseModel(
      status: json['status'] ?? false,
      code: json['code'] ?? 0,
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => RatingModel.fromJson(item))
              .toList() ??
          [],
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'code': code,
      'data': data.map((item) => item.toJson()).toList(),
      'message': message,
    };
  }

  RatingResponseEntity toEntity() {
    return RatingResponseEntity(
      status: status,
      code: code,
      data: data.map((item) => item.toEntity()).toList(),
      message: message,
    );
  }
}

class RatingModel {
  final List<String> images;
  final String id;
  final ConsumerModel consumerId;
  final String merchantId;
  final String jobId;
  final int rating;
  final String review;
  final String byRole;
  final bool isSubmitted;
  final String createdAt;
  final String updatedAt;
  final int v;

  const RatingModel({
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

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      images: (json['images'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          [],
      id: json['_id'] ?? '',
      consumerId: ConsumerModel.fromJson(json['consumerId'] ?? {}),
      merchantId: json['merchantId'] ?? '',
      jobId: json['jobId'] ?? '',
      rating: json['rating'] ?? 0,
      review: json['review'] ?? '',
      byRole: json['byRole'] ?? '',
      isSubmitted: json['isSubmitted'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      v: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'images': images,
      '_id': id,
      'consumerId': consumerId.toJson(),
      'merchantId': merchantId,
      'jobId': jobId,
      'rating': rating,
      'review': review,
      'byRole': byRole,
      'isSubmitted': isSubmitted,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }

  RatingEntity toEntity() {
    return RatingEntity(
      images: images,
      id: id,
      consumerId: consumerId.toEntity(),
      merchantId: merchantId,
      jobId: jobId,
      rating: rating,
      review: review,
      byRole: byRole,
      isSubmitted: isSubmitted,
      createdAt: createdAt,
      updatedAt: updatedAt,
      v: v,
    );
  }
}

class ConsumerModel {
  final LocationModel? location;
  final String id;
  final String? image;
  final String firstName;
  final String lastName;
  final String? phone;
  final String? description;

  const ConsumerModel({
    this.location,
    required this.id,
    this.image,
    required this.firstName,
    required this.lastName,
    this.phone,
    this.description,
  });

  factory ConsumerModel.fromJson(Map<String, dynamic> json) {
    return ConsumerModel(
      location: json['location'] != null
          ? LocationModel.fromJson(json['location'])
          : null,
      id: json['_id'] ?? '',
      image: json['image'],
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      phone: json['phone'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'location': location?.toJson(),
      '_id': id,
      'image': image,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'description': description,
    };
  }

  ConsumerEntity toEntity() {
    return ConsumerEntity(
      location: location?.toEntity(),
      id: id,
      image: image,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      description: description,
    );
  }
}

class LocationModel {
  final String? city;
  final String? state;
  final String? address;
  final String type;
  final List<double> coordinates;

  const LocationModel({
    this.city,
    this.state,
    this.address,
    required this.type,
    required this.coordinates,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      city: json['city'],
      state: json['state'],
      address: json['address'],
      type: json['type'] ?? 'Point',
      coordinates: (json['coordinates'] as List<dynamic>?)
              ?.map((item) => (item as num).toDouble())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'state': state,
      'address': address,
      'type': type,
      'coordinates': coordinates,
    };
  }

  LocationEntity toEntity() {
    return LocationEntity(
      city: city,
      state: state,
      address: address,
      type: type,
      coordinates: coordinates,
    );
  }
}
