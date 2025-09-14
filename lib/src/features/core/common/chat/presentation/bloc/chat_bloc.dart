import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:help_sum/src/core/use_cases/use_case.dart';
import 'package:help_sum/src/features/core/common/chat/domain/entities/chat_message_entity.dart';
import 'package:help_sum/src/features/core/common/chat/domain/entities/inbox_chat_entity.dart';
import 'package:help_sum/src/features/core/common/chat/domain/repositories/chat_repository.dart';
import 'package:help_sum/src/features/core/common/chat/domain/usecases/get_inbox_chats_usecase.dart';
import 'package:help_sum/src/features/core/common/chat/domain/usecases/send_message_usecase.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository _chatRepository;
  final GetInboxChatsUseCase _getInboxChatsUseCase;
  final SendMessageUseCase _sendMessageUseCase;
  StreamSubscription? _messageSubscription;
  StreamSubscription? _chatHistorySubscription;
  StreamSubscription? _errorSubscription;
  StreamSubscription? _messageSentSubscription;

  ChatBloc({
    required ChatRepository chatRepository,
    required GetInboxChatsUseCase getInboxChatsUseCase,
    required SendMessageUseCase sendMessageUseCase,
  }) : _chatRepository = chatRepository,
       _getInboxChatsUseCase = getInboxChatsUseCase,
       _sendMessageUseCase = sendMessageUseCase,
       super(const ChatState()) {
    on<ConnectSocket>(_onConnectSocket);
    on<DisconnectSocket>(_onDisconnectSocket);
    on<LoadInboxChats>(_onLoadInboxChats);
    on<LoadChatHistory>(_onLoadChatHistory);
    on<SendMessage>(_onSendMessage);
    on<MessageReceived>(_onMessageReceived);
    on<MessageSent>(_onMessageSent);
    on<ChatHistoryReceived>(_onChatHistoryReceived);
    on<SocketError>(_onSocketError);
    on<ClearMessages>(_onClearMessages);
  }

  Future<void> _onConnectSocket(
    ConnectSocket event,
    Emitter<ChatState> emit,
  ) async {
    
    emit(state.copyWith(isConnecting: true, errorMessage: ''));

    try {
      await _chatRepository.connectSocket(event.token);

      // Wait for connection to establish with retry mechanism
      bool connected = await _waitForConnection();

      if (connected) {
        // Set up stream subscriptions
        _messageSubscription = _chatRepository.messageStream.listen(
          (message) => add(MessageReceived(message)),
          onError: (error) => add(SocketError(error.toString())),
        );

        _chatHistorySubscription = _chatRepository.chatHistoryStream.listen(
          (messages) => add(ChatHistoryReceived(messages)),
          onError: (error) => add(SocketError(error.toString())),
        );

        _errorSubscription = _chatRepository.errorStream.listen(
          (error) => add(SocketError(error)),
        );

        _messageSentSubscription = _chatRepository.messageSentStream.listen(
          (message) => add(MessageSent(message)),
          onError: (error) => add(SocketError(error.toString())),
        );

        emit(
          state.copyWith(
            isConnecting: false,
            isConnected: true,
            errorMessage: '',
          ),
        );
      } else {
        emit(
          state.copyWith(
            isConnecting: false,
            isConnected: false,
            errorMessage: 'Failed to establish socket connection',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          isConnecting: false,
          isConnected: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<bool> _waitForConnection() async {
    int attempts = 0;
    const maxAttempts = 20; // 4 seconds max wait

    while (attempts < maxAttempts) {
      if (_chatRepository.isConnected) {
        print('Socket connection verified after ${attempts + 1} attempts');
        return true;
      }
      await Future.delayed(const Duration(milliseconds: 200));
      attempts++;
    }

    print('Socket connection timeout after $maxAttempts attempts');
    return false;
  }

  void _onDisconnectSocket(DisconnectSocket event, Emitter<ChatState> emit) {
    _messageSubscription?.cancel();
    _chatHistorySubscription?.cancel();
    _errorSubscription?.cancel();
    _messageSentSubscription?.cancel();

    _chatRepository.disconnectSocket();

    emit(state.copyWith(isConnected: false, messages: [], inboxChats: []));
  }

  Future<void> _onLoadInboxChats(
    LoadInboxChats event,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(isLoadingInbox: true, errorMessage: ''));

    final result = await _getInboxChatsUseCase(NoParams());

    result.fold(
      (failure) => emit(
        state.copyWith(isLoadingInbox: false, errorMessage: failure.message),
      ),
      (chats) => emit(state.copyWith(isLoadingInbox: false, inboxChats: chats)),
    );
  }

  void _onLoadChatHistory(LoadChatHistory event, Emitter<ChatState> emit) {
    emit(
      state.copyWith(
        isLoadingMessages: true,
        errorMessage: '',
        messages: [], // Clear existing messages when loading new chat history
      ),
    );

    // Try to load chat history with retry mechanism
    _loadChatHistoryWithRetry(event.to, emit);
  }

  Future<void> _loadChatHistoryWithRetry(
    String to,
    Emitter<ChatState> emit,
  ) async {
    int attempts = 0;
    const maxAttempts = 10;

    print('Attempting to load chat history for user: $to');

    while (attempts < maxAttempts) {
      if (_chatRepository.isConnected) {
        print('Socket connected, loading chat history...');
        _chatRepository.getChatHistory(to: to);
        return; // Success, exit the retry loop
      }

      print('Socket not connected, attempt ${attempts + 1}/$maxAttempts');
      // Wait a bit before retrying
      await Future.delayed(const Duration(milliseconds: 200));
      attempts++;
    }

    // If we get here, connection failed after all retries
    print('Failed to load chat history after $maxAttempts attempts');
    emit(
      state.copyWith(
        isLoadingMessages: false,
        errorMessage: 'Socket connection timeout. Please try again.',
      ),
    );
  }

  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(isSendingMessage: true, errorMessage: ''));

    final result = await _sendMessageUseCase(
      SendMessageParams(
        receiverId: event.receiverId,
        message: event.message,
        type: event.type,
        mediaUrl: event.mediaUrl,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(isSendingMessage: false, errorMessage: failure.message),
      ),
      (_) => emit(state.copyWith(isSendingMessage: false)),
    );
  }

  void _onMessageReceived(MessageReceived event, Emitter<ChatState> emit) {
    final updatedMessages = List<ChatMessageEntity>.from(state.messages)
      ..add(event.message);

    emit(state.copyWith(messages: updatedMessages));
  }

  void _onMessageSent(MessageSent event, Emitter<ChatState> emit) {
    final updatedMessages = List<ChatMessageEntity>.from(state.messages)
      ..add(event.message);

    emit(state.copyWith(messages: updatedMessages));
  }

  void _onChatHistoryReceived(
    ChatHistoryReceived event,
    Emitter<ChatState> emit,
  ) {
    emit(state.copyWith(messages: event.messages, isLoadingMessages: false));
  }

  void _onSocketError(SocketError event, Emitter<ChatState> emit) {
    emit(state.copyWith(errorMessage: event.error, isLoadingMessages: false));
  }

  void _onClearMessages(ClearMessages event, Emitter<ChatState> emit) {
    emit(
      state.copyWith(
        messages: [],
        isLoadingMessages: true, // Set loading state immediately
        errorMessage: '',
      ),
    );
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    _chatHistorySubscription?.cancel();
    _errorSubscription?.cancel();
    _messageSentSubscription?.cancel();
    _chatRepository.disconnectSocket();
    return super.close();
  }
}
