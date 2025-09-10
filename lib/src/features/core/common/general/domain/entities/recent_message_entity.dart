class RecentMessageEntity {
  final String id;
  final String name;
  final String message;
  final String time;
  final int unreadCount;
  final String? avatarUrl;

  const RecentMessageEntity({
    required this.id,
    required this.name,
    required this.message,
    required this.time,
    this.unreadCount = 0,
    this.avatarUrl,
  });
}
