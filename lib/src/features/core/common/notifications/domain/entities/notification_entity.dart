class NotificationEntity {
  final String id;
  final String title;
  final String body;
  final String type;
  final bool isRead;
  final DateTime createdAt;
  final String? jobId;
  final String? action;
  final NotificationUserEntity user;

  NotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.isRead,
    required this.createdAt,
    this.jobId,
    this.action,
    required this.user,
  });
}

class NotificationUserEntity {
  final String id;
  final String image;
  final String firstName;
  final String lastName;

  NotificationUserEntity({
    required this.id,
    required this.image,
    required this.firstName,
    required this.lastName,
  });
}
