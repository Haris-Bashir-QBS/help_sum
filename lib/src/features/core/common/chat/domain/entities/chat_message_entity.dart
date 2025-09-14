import 'package:equatable/equatable.dart';

class ChatMessageEntity extends Equatable {
  final String id;
  final String senderId;
  final String receiverId;
  final String message;
  final String type;
  final String? mediaUrl;
  final DateTime createdAt;
  final bool? delivered;
  final bool? read;

  const ChatMessageEntity({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.type,
    this.mediaUrl,
    required this.createdAt,
    this.delivered = false,
    this.read = false,
  });

  @override
  List<Object?> get props => [
    id,
    senderId,
    receiverId,
    message,
    type,
    mediaUrl,
    createdAt,
    delivered,
    read,
  ];

  ChatMessageEntity copyWith({
    String? id,
    String? senderId,
    String? receiverId,
    String? message,
    String? type,
    String? mediaUrl,
    DateTime? createdAt,
    bool? delivered,
    bool? read,
  }) {
    return ChatMessageEntity(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      message: message ?? this.message,
      type: type ?? this.type,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      createdAt: createdAt ?? this.createdAt,
      delivered: delivered ?? this.delivered,
      read: read ?? this.read,
    );
  }
}
