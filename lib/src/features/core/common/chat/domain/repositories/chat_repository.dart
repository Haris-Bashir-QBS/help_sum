import 'package:fpdart/fpdart.dart';
import 'package:help_sum/src/core/errors/api_exceptions.dart';
import '../entities/chat_message_entity.dart';
import '../entities/inbox_chat_entity.dart';

abstract interface class ChatRepository {
  Future<Either<Failure, List<InboxChatEntity>>> getInboxChats();
  Future<Either<Failure, void>> sendMessage({
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
