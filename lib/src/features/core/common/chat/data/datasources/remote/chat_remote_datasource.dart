import 'package:help_sum/src/features/core/common/chat/domain/entities/chat_message_entity.dart';
import 'package:help_sum/src/features/core/common/chat/domain/entities/inbox_chat_entity.dart';

abstract interface class ChatRemoteDataSource {
  Future<List<InboxChatEntity>> getInboxChats();
  Future<void> sendMessage({
    required String receiverId,
    required String message,
    String type = 'text',
    String? mediaUrl,
  });
  void getChatHistory({required String to});
  Stream<ChatMessageEntity> get messageStream;
  Stream<List<ChatMessageEntity>> get chatHistoryStream;
  Stream<String> get errorStream;
  Stream<ChatMessageEntity> get messageSentStream;
  Future<void> connectSocket(String token);
  void disconnectSocket();
  bool get isConnected;
}
