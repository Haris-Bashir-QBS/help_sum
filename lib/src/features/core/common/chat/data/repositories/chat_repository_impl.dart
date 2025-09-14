import 'package:fpdart/fpdart.dart';
import 'package:help_sum/src/core/errors/api_exceptions.dart';
import 'package:help_sum/src/features/core/common/chat/data/datasources/remote/chat_remote_datasource.dart';
import 'package:help_sum/src/features/core/common/chat/domain/entities/chat_message_entity.dart';
import 'package:help_sum/src/features/core/common/chat/domain/entities/inbox_chat_entity.dart';
import 'package:help_sum/src/features/core/common/chat/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource _remoteDataSource;

  ChatRepositoryImpl({required ChatRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, List<InboxChatEntity>>> getInboxChats() async {
    try {
      List<InboxChatEntity> chats = await _remoteDataSource.getInboxChats();
      return right(chats);
    } on Failure catch (e) {
      return Left(Failure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> sendMessage({
    required String receiverId,
    required String message,
    String type = 'text',
    String? mediaUrl,
  }) async {
    try {
      await _remoteDataSource.sendMessage(
        receiverId: receiverId,
        message: message,
        type: type,
        mediaUrl: mediaUrl,
      );
      return const Right(null);
    } on Failure catch (e) {
      return Left(Failure(message: e.message));
    }
  }

  @override
  void getChatHistory({required String to}) {
    _remoteDataSource.getChatHistory(to: to);
  }

  @override
  Stream<ChatMessageEntity> get messageStream =>
      _remoteDataSource.messageStream;

  @override
  Stream<List<ChatMessageEntity>> get chatHistoryStream =>
      _remoteDataSource.chatHistoryStream;

  @override
  Stream<String> get errorStream => _remoteDataSource.errorStream;

  @override
  Stream<ChatMessageEntity> get messageSentStream =>
      _remoteDataSource.messageSentStream;

  @override
  Future<void> connectSocket(String token) async {
    await _remoteDataSource.connectSocket(token);
  }

  @override
  void disconnectSocket() {
    _remoteDataSource.disconnectSocket();
  }

  @override
  bool get isConnected => _remoteDataSource.isConnected;
}
