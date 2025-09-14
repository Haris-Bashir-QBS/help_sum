import 'package:fpdart/fpdart.dart';
import 'package:help_sum/src/core/errors/api_exceptions.dart';
import 'package:help_sum/src/core/network/client/dio_client.dart';
import 'package:help_sum/src/core/network/config/api_endpoints.dart';
import 'package:help_sum/src/core/network/config/error_handler.dart';
import 'package:help_sum/src/core/services/socket_service.dart';
import 'package:help_sum/src/features/core/common/chat/data/models/inbox_chat_model.dart';
import 'package:help_sum/src/features/core/common/chat/domain/entities/chat_message_entity.dart';
import 'package:help_sum/src/features/core/common/chat/domain/entities/inbox_chat_entity.dart';
import 'package:help_sum/src/features/core/common/chat/data/datasources/remote/chat_remote_datasource.dart';

import '../../../../../../../core/constants/app_errors.dart';

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final DioClient _client;
  final SocketService _socketService;

  ChatRemoteDataSourceImpl({
    required DioClient client,
    required SocketService socketService,
  }) : _client = client,
       _socketService = socketService;

  @override
  Future<List<InboxChatEntity>> getInboxChats() async {
    return await ApiErrorHandler.executeGuarded(() async {
      final response = await _client.get(
        endpoint: ApiEndpoints.inboxChats.value,
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] as List<dynamic>;
        final List<InboxChatEntity> chats =
            data
                .map((chat) => InboxChatModel.fromJson(chat).toEntity())
                .toList();
        return chats;
      } else {
        throw ServerException(
          statusCode: response.statusCode,
          message: response.data['message'] ?? AppErrors.somethingWentWrong,
        );
      }
    });
  }

  @override
  Future<void> sendMessage({
    required String receiverId,
    required String message,
    String type = 'text',
    String? mediaUrl,
  }) async {
    return await ApiErrorHandler.executeGuarded(() async {
      _socketService.sendMessage(
        receiverId: receiverId,
        message: message,
        type: type,
        mediaUrl: mediaUrl,
      );
    });
  }

  @override
  void getChatHistory({required String to}) {
    _socketService.getChatHistory(to: to);
  }

  @override
  Stream<ChatMessageEntity> get messageStream => _socketService.messageStream;

  @override
  Stream<List<ChatMessageEntity>> get chatHistoryStream =>
      _socketService.chatHistoryStream;

  @override
  Stream<String> get errorStream => _socketService.errorStream;

  @override
  Stream<ChatMessageEntity> get messageSentStream =>
      _socketService.messageSentStream;

  @override
  Future<void> connectSocket(String token) async {
    await _socketService.connect(token);
  }

  @override
  void disconnectSocket() {
    _socketService.disconnect();
  }

  @override
  bool get isConnected => _socketService.isConnected;
}
