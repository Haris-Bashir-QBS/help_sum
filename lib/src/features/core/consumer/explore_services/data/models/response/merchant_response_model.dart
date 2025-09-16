class MerchantResponseModel {
  final bool status;
  final int code;
  final MerchantData data;
  final String message;

  MerchantResponseModel({
    required this.status,
    required this.code,
    required this.data,
    required this.message,
  });

  factory MerchantResponseModel.fromJson(Map<String, dynamic> json) {
    return MerchantResponseModel(
      status: json['status'] ?? false,
      code: json['code'] ?? 0,
      data: MerchantData.fromJson(json['data'] ?? {}),
      message: json['message'] ?? '',
    );
  }
}

class MerchantData {
  final List<MerchantModel> data;
  final PaginationModel pagination;

  MerchantData({required this.data, required this.pagination});

  factory MerchantData.fromJson(Map<String, dynamic> json) {
    return MerchantData(
      data:
          (json['data'] as List<dynamic>? ?? [])
              .map((item) => MerchantModel.fromJson(item))
              .toList(),
      pagination: PaginationModel.fromJson(json['pagination'] ?? {}),
    );
  }
}

class MerchantModel {
  final String id;
  final String firstName;
  final String lastName;
  final String? image;
  final String? rating;
  final String? distance;
  final String? email;
  final String phone;
  final String description;
  final double hourlyRate;
  final List<ServiceModel> services;
  final List<String> media;
  final LocationModel location;

  MerchantModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.image,
    this.rating,
    this.email,
    required this.phone,
    required this.description,
    required this.hourlyRate,
    required this.services,
    required this.media,
    this.distance,
    required this.location,
  });

  factory MerchantModel.fromJson(Map<String, dynamic> json) {
    return MerchantModel(
      id: json['_id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      image: json['image'],
      email: json['email'],
      phone: json['phone'] ?? '',
      description: json['description'] ?? '',
      hourlyRate: (json['hourlyRate'] ?? 0).toDouble(),
      services:
          (json['services'] as List<dynamic>? ?? [])
              .map((item) => ServiceModel.fromJson(item))
              .toList(),
      media: (json['Media'] as List<dynamic>? ?? []).cast<String>(),
      location: LocationModel.fromJson(json['location'] ?? {}),
      rating: json['rating'] != null ? (json['rating'])?.toString() : null,
      distance:
          json['distance'] != null
              ? (json['distance'] as num).toStringAsFixed(3)
              : null,
    );
  }
}

class ServiceModel {
  final String id;
  // final CategoryInfo categoryId;
  final String? categoryId;
  final String name;

  ServiceModel({
    required this.id,
    required this.categoryId,
    required this.name,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['_id'] ?? '',
      //  categoryId: CategoryInfo.fromJson(json['categoryId'] ?? {}),
      categoryId: json['categoryId'] as String?,
      name: json['name'] ?? '',
    );
  }
}

class CategoryInfo {
  final String id;
  final String name;

  CategoryInfo({required this.id, required this.name});

  factory CategoryInfo.fromJson(Map<String, dynamic> json) {
    return CategoryInfo(id: json['_id'] ?? '', name: json['name'] ?? '');
  }
}

class LocationModel {
  final String city;
  final String state;
  final String address;
  final String type;
  final List<double> coordinates;

  LocationModel({
    required this.city,
    required this.state,
    required this.address,
    required this.type,
    required this.coordinates,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      address: json['address'] ?? '',
      type: json['type'] ?? '',
      coordinates:
          (json['coordinates'] as List<dynamic>? ?? [])
              .map((e) => (e as num).toDouble())
              .toList(),
    );
  }
}

class PaginationModel {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  PaginationModel({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      totalPages: json['totalPages'] ?? 1,
    );
  }
}
