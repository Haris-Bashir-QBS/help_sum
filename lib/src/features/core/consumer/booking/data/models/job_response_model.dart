class JobResponseModel {
  final bool status;
  final int code;
  final JobListData data;
  final String message;

  JobResponseModel({
    required this.status,
    required this.code,
    required this.data,
    required this.message,
  });

  factory JobResponseModel.fromJson(Map<String, dynamic> json) {
    return JobResponseModel(
      status: json['status'] ?? false,
      code: json['code'] ?? 0,
      data: JobListData.fromJson(json['data'] ?? {}),
      message: json['message'] ?? '',
    );
  }
}

class JobListData {
  final List<JobData> data;
  final Pagination pagination;

  JobListData({required this.data, required this.pagination});

  factory JobListData.fromJson(Map<String, dynamic> json) {
    return JobListData(
      data:
          (json['data'] as List<dynamic>? ?? [])
              .map((e) => JobData.fromJson(e))
              .toList(),
      pagination: Pagination.fromJson(json['pagination'] ?? {}),
    );
  }
}

class Pagination {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  Pagination({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      totalPages: json['totalPages'] ?? 1,
    );
  }
}

class ServiceInfo {
  final String id;
  final String name;

  ServiceInfo({required this.id, required this.name});

  factory ServiceInfo.fromJson(Map<String, dynamic> json) {
    return ServiceInfo(id: json['_id'] ?? '', name: json['name'] ?? '');
  }
}

class JobData {
  final UserInfo consumerId;
  final UserInfo merchantId;
  final ServiceInfo serviceId;
  final String title;
  final String description;
  final JobLocation location;
  final String date;
  final String time;
  final String estimatedWorkTime;
  final int offer;
  final List<String> media;
  final bool isVerified;
  final String? jobStartTime;
  final String? jobEndTime;
  final String status;
  final String? by;
  final String paymentStatus;
  final int paymentAmount;
  final String? stripeTransferId;
  final String? completedAt;
  final String id;
  final String createdAt;
  final String updatedAt;
  final bool? isConsumerRated, isMerchantRated;
  final int v;

  JobData({
    required this.consumerId,
    required this.merchantId,
    required this.serviceId,
    required this.title,
    required this.description,
    required this.location,
    required this.date,
    this.isConsumerRated,
    this.isMerchantRated,
    required this.time,
    required this.estimatedWorkTime,
    required this.offer,
    required this.media,
    required this.isVerified,
    this.jobStartTime,
    this.jobEndTime,
    required this.status,
    this.by,
    required this.paymentStatus,
    required this.paymentAmount,
    this.stripeTransferId,
    this.completedAt,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory JobData.fromJson(Map<String, dynamic> json) {
    return JobData(
      //  consumerId: json['consumerId'] ?? '',
      //merchantId: UserInfo.fromJson(json['merchantId']),
      consumerId:
          json['consumerId'] is Map
              ? UserInfo.fromJson(json['consumerId'])
              : UserInfo(
                id: json['consumerId'] ?? '',
                firstName: '',
                lastName: '',
                phone: '',
              ),
      merchantId:
          json['merchantId'] is Map
              ? UserInfo.fromJson(json['merchantId'])
              : UserInfo(
                id: json['merchantId'] ?? '',
                firstName: '',
                lastName: '',
                phone: '',
              ),
      serviceId: _parseServiceInfo(json['serviceId']),
      isConsumerRated: json['consumerIsRated'] ?? false,
      isMerchantRated: json['merchantIsRated'] ?? false,

      title: json['title'] ?? '',
      description: json['description'] ?? '',
      location: JobLocation.fromJson(json['location'] ?? {}),
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      estimatedWorkTime: json['estimatedWorkTime'] ?? '',
      offer: json['offer'] ?? 0,
      media: (json['media'] as List<dynamic>? ?? []).cast<String>(),
      isVerified: json['isVerified'] ?? false,
      jobStartTime: json['jobStartTime'],
      jobEndTime: json['jobEndTime'],
      status: json['status'] ?? '',
      by: json['by'],
      paymentStatus: json['paymentStatus'] ?? '',
      paymentAmount: json['paymentAmount'] ?? 0,
      stripeTransferId: json['stripeTransferId'],
      completedAt: json['completedAt'],
      id: json['_id'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      v: json['__v'] ?? 0,
    );
  }
}

ServiceInfo _parseServiceInfo(dynamic data) {
  if (data is Map<String, dynamic>) {
    return ServiceInfo.fromJson(data);
  } else if (data is String) {
    return ServiceInfo(id: data, name: ''); // Replace with your constructor
  }
  return ServiceInfo(id: '', name: '');
}

class UserInfo {
  final String id;
  final String? image;
  final String firstName;
  final String lastName;
  final String phone;
  final String? description;
  final JobLocation? location;
  final String? averageRating;
  final String? reviewCount;
  //final String? reviews;

  UserInfo({
    required this.id,
    this.image,
    required this.firstName,
    required this.lastName,
    required this.phone,
    this.description,
    this.location,
    this.averageRating,
    this.reviewCount,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['_id'] ?? '',
      image: json['image'],
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      phone: json['phone'] ?? '',
      description: json['description'],
      location: JobLocation.fromJson(json['location'] ?? {}),
      averageRating: json['averageRating']?.toString(),
      reviewCount: json['ratingCount']?.toString(),
    );
  }
}

class JobLocation {
  final String city;
  final String state;
  final String address;
  final List<double> coordinates;
  final String type;

  JobLocation({
    required this.city,
    required this.state,
    required this.address,
    required this.coordinates,
    required this.type,
  });

  factory JobLocation.fromJson(Map<String, dynamic> json) {
    return JobLocation(
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      address: json['address'] ?? '',
      coordinates:
          (json['coordinates'] as List<dynamic>? ?? [])
              .map((e) => (e as num).toDouble())
              .toList(),
      type: json['type'] ?? '',
    );
  }
}
