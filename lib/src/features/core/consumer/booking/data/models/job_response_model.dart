import 'package:help_sum/src/core/models/common/paginated_model.dart';

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
  final PaginationModel pagination;

  JobListData({required this.data, required this.pagination});

  factory JobListData.fromJson(Map<String, dynamic> json) {
    return JobListData(
      data:
          (json['data'] as List<dynamic>? ?? [])
              .map((e) => JobData.fromJson(e))
              .toList(),
      pagination: PaginationModel.fromJson(json['pagination'] ?? {}),
    );
  }
}

class JobData {
  final String consumerId;
  final MerchantInfo merchantId;
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
  final int v;

  JobData({
    required this.consumerId,
    required this.merchantId,
    required this.serviceId,
    required this.title,
    required this.description,
    required this.location,
    required this.date,
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
      consumerId: json['consumerId'] ?? '',
      merchantId: MerchantInfo.fromJson(json['merchantId'] ?? {}),
      serviceId: ServiceInfo.fromJson(json['serviceId'] ?? {}),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      location: JobLocation.fromJson(json['location'] ?? {}),
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      estimatedWorkTime: json['estimatedWorkTime'].toString(),
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

class MerchantInfo {
  final String id;
  final String? email;

  MerchantInfo({required this.id, this.email});

  factory MerchantInfo.fromJson(Map<String, dynamic> json) {
    return MerchantInfo(id: json['_id'] ?? '', email: json['email']);
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
