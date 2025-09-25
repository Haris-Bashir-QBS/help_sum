import '../../domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  NotificationModel({
    required super.id,
    required super.title,
    required super.body,
    required super.type,
    required super.isRead,
    required super.createdAt,
    super.jobId,
    super.action,
    required NotificationUserModel super.user,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'] as String? ?? "",
      title: json['title'] as String? ?? "",
      body: json['body'] as String? ?? "",
      type: json['type'] as String? ?? "",
      isRead: json['isRead'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      jobId: json['data']?['jobId'] as String?,
      action: json['data']?['action'] as String?,
      user: NotificationUserModel.fromJson(json['userId']),
    );
  }
}

class NotificationUserModel extends NotificationUserEntity {
  NotificationUserModel({
    required super.id,
    required super.image,
    required super.firstName,
    required super.lastName,
  });

  factory NotificationUserModel.fromJson(Map<String, dynamic> json) {
    return NotificationUserModel(
      id: json['_id'] as String,
      image: json['image'] as String? ?? "",
      firstName: json['firstName'] as String? ?? "",
      lastName: json['lastName'] as String? ?? "",
    );
  }
}
