import 'package:equatable/equatable.dart';
import '../../domain/entities/chat_message_entity.dart';

class ChatMessageModel extends Equatable {
  final String id;
  final String senderId;
  final String receiverId;
  final String message;
  final String type;
  final String? mediaUrl;
  final String createdAt;
  final bool delivered;
  final bool read;

  const ChatMessageModel({
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

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id']?.toString() ?? '',
      senderId: json['sender']?.toString() ?? '',
      receiverId: json['receiver']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      type: json['type']?.toString() ?? 'text',
      mediaUrl: json['mediaUrl']?.toString(),
      createdAt: json['created_at']?.toString() ?? DateTime.now().toIso8601String(),
      delivered: json['delivered'] == true,
      read: json['read'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender': senderId,
      'receiver': receiverId,
      'message': message,
      'type': type,
      'mediaUrl': mediaUrl,
      'created_at': createdAt,
      'delivered': delivered,
      'read': read,
    };
  }

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

  ChatMessageModel copyWith({
    String? id,
    String? senderId,
    String? receiverId,
    String? message,
    String? type,
    String? mediaUrl,
    String? createdAt,
    bool? delivered,
    bool? read,
  }) {
    return ChatMessageModel(
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

extension ChatMessageModelX on ChatMessageModel {
  ChatMessageEntity toEntity() {
    return ChatMessageEntity(
      id: id,
      senderId: senderId,
      receiverId: receiverId,
      message: message,
      type: type,
      mediaUrl: mediaUrl,
      createdAt: DateTime.parse(createdAt),
      delivered: delivered,
      read: read,
    );
  }
}
