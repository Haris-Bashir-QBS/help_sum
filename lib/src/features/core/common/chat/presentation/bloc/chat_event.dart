part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class ConnectSocket extends ChatEvent {
  final String token;

  const ConnectSocket({required this.token});

  @override
  List<Object?> get props => [token];
}

class ReconnectSocket extends ChatEvent {
  final String token;

  const ReconnectSocket({required this.token});

  @override
  List<Object?> get props => [token];
}

class DisconnectSocket extends ChatEvent {
  const DisconnectSocket();
}

class LoadInboxChats extends ChatEvent {
  const LoadInboxChats();
}

class LoadChatHistory extends ChatEvent {
  final String to;

  const LoadChatHistory({required this.to});

  @override
  List<Object?> get props => [to];
}

class SendMessage extends ChatEvent {
  final String receiverId;
  final String message;
  final String type;
  final String? mediaUrl;

  const SendMessage({
    required this.receiverId,
    required this.message,
    this.type = 'text',
    this.mediaUrl,
  });

  @override
  List<Object?> get props => [receiverId, message, type, mediaUrl];
}

class MessageReceived extends ChatEvent {
  final ChatMessageEntity message;

  const MessageReceived(this.message);

  @override
  List<Object?> get props => [message];
}

class MessageSent extends ChatEvent {
  final ChatMessageEntity message;

  const MessageSent(this.message);

  @override
  List<Object?> get props => [message];
}

class ChatHistoryReceived extends ChatEvent {
  final List<ChatMessageEntity> messages;

  const ChatHistoryReceived(this.messages);

  @override
  List<Object?> get props => [messages];
}

class SocketError extends ChatEvent {
  final String error;

  const SocketError(this.error);

  @override
  List<Object?> get props => [error];
}

class ClearMessages extends ChatEvent {
  const ClearMessages();
}
