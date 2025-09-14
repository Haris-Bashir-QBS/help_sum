part of 'chat_bloc.dart';

class ChatState extends Equatable {
  const ChatState({
    this.isConnected = false,
    this.isConnecting = false,
    this.isLoadingInbox = true, // Show loading by default for inbox
    this.isLoadingMessages = true, // Show loading by default for messages
    this.isSendingMessage = false,
    this.messages = const [],
    this.inboxChats = const [],
    this.currentChatUserId = '',
    this.errorMessage = '',
  });

  final bool isConnected;
  final bool isConnecting;
  final bool isLoadingInbox;
  final bool isLoadingMessages;
  final bool isSendingMessage;
  final List<ChatMessageEntity> messages;
  final List<InboxChatEntity> inboxChats;
  final String currentChatUserId;
  final String errorMessage;

  @override
  List<Object?> get props => [
        isConnected,
        isConnecting,
        isLoadingInbox,
        isLoadingMessages,
        isSendingMessage,
        messages,
        inboxChats,
        currentChatUserId,
        errorMessage,
      ];

  ChatState copyWith({
    bool? isConnected,
    bool? isConnecting,
    bool? isLoadingInbox,
    bool? isLoadingMessages,
    bool? isSendingMessage,
    List<ChatMessageEntity>? messages,
    List<InboxChatEntity>? inboxChats,
    String? currentChatUserId,
    String? errorMessage,
  }) {
    return ChatState(
      isConnected: isConnected ?? this.isConnected,
      isConnecting: isConnecting ?? this.isConnecting,
      isLoadingInbox: isLoadingInbox ?? this.isLoadingInbox,
      isLoadingMessages: isLoadingMessages ?? this.isLoadingMessages,
      isSendingMessage: isSendingMessage ?? this.isSendingMessage,
      messages: messages ?? this.messages,
      inboxChats: inboxChats ?? this.inboxChats,
      currentChatUserId: currentChatUserId ?? this.currentChatUserId,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
