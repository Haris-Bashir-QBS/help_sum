import 'package:equatable/equatable.dart';
import 'chat_message_entity.dart';

class InboxChatEntity extends Equatable {
  final String userId;
  final String firstName;
  final String lastName;
  final String? image;
  final ChatMessageEntity? lastMessage;
  final int unreadCount;

  const InboxChatEntity({
    required this.userId,
    required this.firstName,
    required this.lastName,
    this.image,
    this.lastMessage,
    this.unreadCount = 0,
  });

  @override
  List<Object?> get props => [
        userId,
        firstName,
        lastName,
        image,
        lastMessage,
        unreadCount,
      ];

  InboxChatEntity copyWith({
    String? userId,
    String? firstName,
    String? lastName,
    String? image,
    ChatMessageEntity? lastMessage,
    int? unreadCount,
  }) {
    return InboxChatEntity(
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      image: image ?? this.image,
      lastMessage: lastMessage ?? this.lastMessage,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}
