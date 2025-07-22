// // ENTITY LAYER (PURE CLASSES)
//
// class MerchantJobRequestsEntity {
//   final bool? status;
//   final int? code;
//   final MerchantJobRequestsDataEntity? data;
//   final String? message;
//
//   MerchantJobRequestsEntity({this.status, this.code, this.data, this.message});
// }
//
// class MerchantJobRequestsDataEntity {
//   final List<JobRequestEntity>? data;
//   final PaginationEntity? pagination;
//
//   MerchantJobRequestsDataEntity({this.data, this.pagination});
// }
//
// class PaginationEntity {
//   final int? total;
//   final int? page;
//   final int? limit;
//   final int? totalPages;
//
//   PaginationEntity({this.total, this.page, this.limit, this.totalPages});
// }
//
// // class JobRequestEntity {
// //   final String? id;
// //   final LocationEntity? location;
// //   final ConsumerEntity? consumerId;
// //   final String? merchantId;
// //   final ServiceEntity? serviceId;
// //   final String? title;
// //   final String? description;
// //   final String? date;
// //   final String? time;
// //   final String? estimatedWorkTime;
// //   final int? offer;
// //   final List<dynamic>? media;
// //   final bool? isVerified;
// //   final String? jobStartTime;
// //   final String? jobEndTime;
// //   final String? status;
// //   final String? by;
// //   final String? paymentStatus;
// //   final int? paymentAmount;
// //   final String? stripeTransferId;
// //   final String? completedAt;
// //   final String? createdAt;
// //   final String? updatedAt;
// //   final int? v;
// //
// //   JobRequestEntity({
// //     this.id,
// //     this.location,
// //     this.consumerId,
// //     this.merchantId,
// //     this.serviceId,
// //     this.title,
// //     this.description,
// //     this.date,
// //     this.time,
// //     this.estimatedWorkTime,
// //     this.offer,
// //     this.media,
// //     this.isVerified,
// //     this.jobStartTime,
// //     this.jobEndTime,
// //     this.status,
// //     this.by,
// //     this.paymentStatus,
// //     this.paymentAmount,
// //     this.stripeTransferId,
// //     this.completedAt,
// //     this.createdAt,
// //     this.updatedAt,
// //     this.v,
// //   });
// // }
//
// class LocationEntity {
//   final String? city;
//   final String? state;
//   final String? address;
//   final List<double>? coordinates;
//   final String? type;
//
//   LocationEntity({
//     this.city,
//     this.state,
//     this.address,
//     this.coordinates,
//     this.type,
//   });
// }
//
// class ConsumerEntity {
//   final String? id;
//   final String? email;
//
//   ConsumerEntity({this.id, this.email});
// }
//
// class ServiceEntity {
//   final String? id;
//   final String? name;
//
//   ServiceEntity({this.id, this.name});
// }
