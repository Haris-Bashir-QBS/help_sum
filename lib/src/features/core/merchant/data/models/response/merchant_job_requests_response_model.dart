// import 'package:help_sum/src/features/core/merchant/domain/entities/merchant_job_request_resposne_entity.dart';
//
// class MerchantJobRequestsModel extends MerchantJobRequestsEntity {
//   MerchantJobRequestsModel({
//     super.status,
//     super.code,
//     MerchantJobRequestsDataModel? super.data,
//     super.message,
//   });
//
//   factory MerchantJobRequestsModel.fromJson(Map<String, dynamic> json) {
//     return MerchantJobRequestsModel(
//       status: json['status'],
//       code: json['code'],
//       data:
//           json['data'] != null
//               ? MerchantJobRequestsDataModel.fromJson(json['data'])
//               : null,
//       message: json['message'],
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     'status': status,
//     'code': code,
//     'data': (data as MerchantJobRequestsDataModel?)?.toJson(),
//     'message': message,
//   };
// }
//
// class MerchantJobRequestsDataModel extends MerchantJobRequestsDataEntity {
//   MerchantJobRequestsDataModel({
//     List<JobRequestModel>? data,
//     PaginationModel? pagination,
//   }) : super(data: data, pagination: pagination);
//
//   factory MerchantJobRequestsDataModel.fromJson(Map<String, dynamic> json) {
//     return MerchantJobRequestsDataModel(
//       data:
//           (json['data'] as List<dynamic>?)
//               ?.map((e) => JobRequestModel.fromJson(e))
//               .toList(),
//       pagination:
//           json['pagination'] != null
//               ? PaginationModel.fromJson(json['pagination'])
//               : null,
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     'data': (data as List<JobRequestModel>?)?.map((e) => e.toJson()).toList(),
//     'pagination': (pagination as PaginationModel?)?.toJson(),
//   };
// }
//
// class PaginationModel extends PaginationEntity {
//   PaginationModel({super.total, super.page, super.limit, super.totalPages});
//
//   factory PaginationModel.fromJson(Map<String, dynamic> json) {
//     return PaginationModel(
//       total: json['total'],
//       page: json['page'],
//       limit: json['limit'],
//       totalPages: json['totalPages'],
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     'total': total,
//     'page': page,
//     'limit': limit,
//     'totalPages': totalPages,
//   };
// }
//
// class JobRequestModel extends JobRequestEntity {
//   JobRequestModel({
//     super.id,
//     LocationModel? super.location,
//     ConsumerModel? super.consumerId,
//     super.merchantId,
//     ServiceModel? super.serviceId,
//     super.title,
//     super.description,
//     super.date,
//     super.time,
//     super.estimatedWorkTime,
//     super.offer,
//     super.media,
//     super.isVerified,
//     super.jobStartTime,
//     super.jobEndTime,
//     super.status,
//     super.by,
//     super.paymentStatus,
//     super.paymentAmount,
//     super.stripeTransferId,
//     super.completedAt,
//     super.createdAt,
//     super.updatedAt,
//     super.v,
//   });
//
//   factory JobRequestModel.fromJson(Map<String, dynamic> json) {
//     return JobRequestModel(
//       id: json['_id'],
//       location:
//           json['location'] != null
//               ? LocationModel.fromJson(json['location'])
//               : null,
//       consumerId:
//           json['consumerId'] != null
//               ? ConsumerModel.fromJson(json['consumerId'])
//               : null,
//       merchantId: json['merchantId'],
//       serviceId:
//           json['serviceId'] != null
//               ? ServiceModel.fromJson(json['serviceId'])
//               : null,
//       title: json['title'],
//       description: json['description'],
//       date: json['date'],
//       time: json['time'],
//       estimatedWorkTime: json['estimatedWorkTime'],
//       offer: json['offer'],
//       media: json['media'],
//       isVerified: json['isVerified'],
//       jobStartTime: json['jobStartTime'],
//       jobEndTime: json['jobEndTime'],
//       status: json['status'],
//       by: json['by'],
//       paymentStatus: json['paymentStatus'],
//       paymentAmount: json['paymentAmount'],
//       stripeTransferId: json['stripeTransferId'],
//       completedAt: json['completedAt'],
//       createdAt: json['createdAt'],
//       updatedAt: json['updatedAt'],
//       v: json['__v'],
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     '_id': id,
//     'location': (location as LocationModel?)?.toJson(),
//     'consumerId': (consumerId as ConsumerModel?)?.toJson(),
//     'merchantId': merchantId,
//     'serviceId': (serviceId as ServiceModel?)?.toJson(),
//     'title': title,
//     'description': description,
//     'date': date,
//     'time': time,
//     'estimatedWorkTime': estimatedWorkTime,
//     'offer': offer,
//     'media': media,
//     'isVerified': isVerified,
//     'jobStartTime': jobStartTime,
//     'jobEndTime': jobEndTime,
//     'status': status,
//     'by': by,
//     'paymentStatus': paymentStatus,
//     'paymentAmount': paymentAmount,
//     'stripeTransferId': stripeTransferId,
//     'completedAt': completedAt,
//     'createdAt': createdAt,
//     'updatedAt': updatedAt,
//     '__v': v,
//   };
// }
//
// class LocationModel extends LocationEntity {
//   LocationModel({
//     String? city,
//     String? state,
//     String? address,
//     List<double>? coordinates,
//     String? type,
//   }) : super(
//          city: city,
//          state: state,
//          address: address,
//          coordinates: coordinates,
//          type: type,
//        );
//
//   factory LocationModel.fromJson(Map<String, dynamic> json) {
//     return LocationModel(
//       city: json['city'],
//       state: json['state'],
//       address: json['address'],
//       coordinates:
//           (json['coordinates'] as List<dynamic>?)
//               ?.map((e) => (e as num).toDouble())
//               .toList(),
//       type: json['type'],
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     'city': city,
//     'state': state,
//     'address': address,
//     'coordinates': coordinates,
//     'type': type,
//   };
// }
//
// class ConsumerModel extends ConsumerEntity {
//   ConsumerModel({String? id, String? email}) : super(id: id, email: email);
//
//   factory ConsumerModel.fromJson(Map<String, dynamic> json) {
//     return ConsumerModel(id: json['_id'], email: json['email']);
//   }
//
//   Map<String, dynamic> toJson() => {'_id': id, 'email': email};
// }
//
// class ServiceModel extends ServiceEntity {
//   ServiceModel({String? id, String? name}) : super(id: id, name: name);
//
//   factory ServiceModel.fromJson(Map<String, dynamic> json) {
//     return ServiceModel(id: json['_id'], name: json['name']);
//   }
//
//   Map<String, dynamic> toJson() => {'_id': id, 'name': name};
// }
