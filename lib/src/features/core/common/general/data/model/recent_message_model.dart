import 'package:help_sum/src/features/core/common/general/domain/entities/recent_message_entity.dart';

class RecentMessageModel extends RecentMessageEntity {
  const RecentMessageModel({
    required super.id,
    required super.name,
    required super.message,
    required super.time,
    super.unreadCount,
    super.avatarUrl,
  });

  factory RecentMessageModel.fromJson(Map<String, dynamic> json) {
    return RecentMessageModel(
      id: json['id'] as String,
      name: json['name'] as String,
      message: json['message'] as String,
      time: json['time'] as String,
      unreadCount: json['unread_count'] as int? ?? 0,
      avatarUrl: json['avatar_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'message': message,
      'time': time,
      'unread_count': unreadCount,
      'avatar_url': avatarUrl,
    };
  }
}
