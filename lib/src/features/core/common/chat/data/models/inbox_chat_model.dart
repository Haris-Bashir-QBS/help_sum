import 'package:equatable/equatable.dart';
import '../../domain/entities/inbox_chat_entity.dart';
import 'chat_message_model.dart';

class InboxChatModel extends Equatable {
  final SenderUserModel user;
  final ChatMessageModel? lastMessage;
  final int unreadCount;

  const InboxChatModel({
    required this.user,
    this.lastMessage,
    this.unreadCount = 0,
  });

  factory InboxChatModel.fromJson(Map<String, dynamic> json) {
    return InboxChatModel(
      user: SenderUserModel.fromJson(json['user']),
      lastMessage:
          json['lastMessage'] != null
              ? ChatMessageModel.fromJson(json['lastMessage'])
              : null,
      unreadCount: json['unreadCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'lastMessage': lastMessage?.toJson(),
      'unreadCount': unreadCount,
    };
  }

  @override
  List<Object?> get props => [user, lastMessage, unreadCount];

  InboxChatModel copyWith({
    SenderUserModel? user,
    ChatMessageModel? lastMessage,
    int? unreadCount,
  }) {
    return InboxChatModel(
      user: user ?? this.user,
      lastMessage: lastMessage ?? this.lastMessage,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}

class SenderUserModel extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String? image;

  const SenderUserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.image,
  });

  factory SenderUserModel.fromJson(Map<String, dynamic> json) {
    return SenderUserModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      firstName: json['firstName']?.toString() ?? '',
      lastName: json['lastName']?.toString() ?? '',
      image: json['image']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstName': firstName,
      'lastName': lastName,
      'image': image,
    };
  }

  @override
  List<Object?> get props => [id, firstName, lastName, image];

  SenderUserModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? image,
  }) {
    return SenderUserModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      image: image ?? this.image,
    );
  }
}

extension InboxChatModelX on InboxChatModel {
  InboxChatEntity toEntity() {
    return InboxChatEntity(
      userId: user.id,
      firstName: user.firstName,
      lastName: user.lastName,
      image: user.image,
      lastMessage: lastMessage?.toEntity(),
      unreadCount: unreadCount,
    );
  }
}
