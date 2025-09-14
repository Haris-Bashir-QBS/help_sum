import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:help_sum/src/core/network/config/api_base.dart';
import 'package:help_sum/src/features/core/common/chat/domain/entities/chat_message_entity.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  IO.Socket? _socket;
  StreamController<ChatMessageEntity> _messageController =
      StreamController<ChatMessageEntity>.broadcast();
  StreamController<List<ChatMessageEntity>> _chatHistoryController =
      StreamController<List<ChatMessageEntity>>.broadcast();
  StreamController<String> _errorController =
      StreamController<String>.broadcast();
  StreamController<ChatMessageEntity> _messageSentController =
      StreamController<ChatMessageEntity>.broadcast();

  // Getters for streams
  Stream<ChatMessageEntity> get messageStream => _messageController.stream;
  Stream<List<ChatMessageEntity>> get chatHistoryStream =>
      _chatHistoryController.stream;
  Stream<String> get errorStream => _errorController.stream;
  Stream<ChatMessageEntity> get messageSentStream =>
      _messageSentController.stream;

  bool get isConnected => _socket?.connected ?? false;

  Future<void> connect(String token) async {
    try {
      if (_socket != null) {
        _socket!.disconnect();
        _socket = null;
      }

      _socket = IO.io(
        ApiBase.baseUrl,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .enableForceNew()
            .setExtraHeaders({'token': token})
            .enableAutoConnect()
            .setTimeout(10000) // 10 second timeout
            .build(),
      );

      _setupEventListeners();

      // Wait for connection to be established
      await _waitForConnection();
    } catch (e) {
      _errorController.add('Connection failed: $e');
    }
  }

  Future<void> _waitForConnection() async {
    int attempts = 0;
    const maxAttempts = 20; // 2 seconds max wait

    while (attempts < maxAttempts && (_socket?.connected != true)) {
      await Future.delayed(const Duration(milliseconds: 100));
      attempts++;
    }

    if (_socket?.connected != true) {
      _errorController.add('Connection timeout');
    }
  }

  void logout() {
    dispose(); // close everything
    _initControllers(); // make fresh controllers for next login
  }

  void _initControllers() {
    _messageController = StreamController<ChatMessageEntity>.broadcast();
    _chatHistoryController =
        StreamController<List<ChatMessageEntity>>.broadcast();
    _errorController = StreamController<String>.broadcast();
    _messageSentController = StreamController<ChatMessageEntity>.broadcast();
  }

  void _setupEventListeners() {
    if (_socket == null) return;

    // Clear any existing listeners to prevent duplicates
    _socket!.clearListeners();

    // Connection events
    _socket!.onConnect((_) {
      debugPrint('Socket connected successfully');
    });

    _socket!.onDisconnect((_) {
      debugPrint('Socket disconnected');
    });

    _socket!.onConnectError((error) {
      debugPrint('Socket connection error: $error');
      _errorController.add('Connection error: $error');
    });

    // Chat events
    _socket!.on('response', (data) {
      debugPrint('Socket response: $data');
      try {
        // Check if this is a chat history response
        if (data is List) {
          // This is chat history data
          final List<ChatMessageEntity> chatMessages =
              data.map((msg) => _parseChatMessage(msg)).toList();
          _chatHistoryController.add(chatMessages);
        }
      } catch (e) {
        _errorController.add('Error parsing response: $e');
      }
    });

    _socket!.on('error', (data) {
      debugPrint('Socket error: $data');
      _errorController.add(data.toString());
    });

    // Note: chat_history event is no longer used, response event now handles chat history
    // _socket!.on('chat_history', (data) {
    //   debugPrint('Chat history received: $data');
    //   try {
    //     final List<dynamic> messages = data as List<dynamic>;
    //     final List<ChatMessageEntity> chatMessages =
    //         messages.map((msg) => _parseChatMessage(msg)).toList();
    //     _chatHistoryController.add(chatMessages);
    //   } catch (e) {
    //     _errorController.add('Error parsing chat history: $e');
    //   }
    // });

    _socket!.on('receive_message', (data) {
      debugPrint('Message received: $data');
      try {
        final message = _parseChatMessage(data);
        debugPrint(
          'Parsed received message - Sender ID: ${message.senderId}, Receiver ID: ${message.receiverId}',
        );
        _messageController.add(message);
      } catch (e) {
        _errorController.add('Error parsing received message: $e');
      }
    });

    _socket!.on('message_sent', (data) {
      debugPrint('Message sent confirmation: $data');
      try {
        final message = _parseChatMessage(data);
        debugPrint(
          'Parsed sent message - Sender ID: ${message.senderId}, Receiver ID: ${message.receiverId}',
        );
        _messageSentController.add(message);
      } catch (e) {
        _errorController.add('Error parsing sent message: $e');
      }
    });
  }

  ChatMessageEntity _parseChatMessage(dynamic data) {
    // Handle different response formats
    String senderId = '';
    String receiverId = '';

    // Check if sender/receiver are nested objects (new format)
    if (data['sender'] is Map && data['receiver'] is Map) {
      senderId = data['sender']['_id']?.toString() ?? '';
      receiverId = data['receiver']['_id']?.toString() ?? '';
    } else {
      // Handle simple string format (old format)
      senderId = data['sender']?.toString() ?? '';
      receiverId = data['receiver']?.toString() ?? '';
    }

    return ChatMessageEntity(
      id: data['_id']?.toString() ?? data['id']?.toString() ?? '',
      senderId: senderId,
      receiverId: receiverId,
      message: data['message']?.toString() ?? '',
      type: data['type']?.toString() ?? 'text',
      mediaUrl: data['mediaUrl']?.toString(),
      createdAt:
          DateTime.tryParse(
            data['createdAt']?.toString() ??
                data['created_at']?.toString() ??
                '',
          ) ??
          DateTime.now(),
      delivered: data['delivered'] == true,
      read: data['read'] == true,
    );
  }

  void sendMessage({
    required String receiverId,
    required String message,
    String type = 'text',
    String? mediaUrl,
  }) {
    if (_socket?.connected != true) {
      _errorController.add('Socket not connected');
      return;
    }

    _socket!.emit('send_message', {
      'to': receiverId,
      'message': message,
      // 'type': type,
      // 'mediaUrl': mediaUrl,
    });
  }

  void getChatHistory({required String to}) {
    if (_socket?.connected != true) {
      _errorController.add('Socket not connected');
      return;
    }

    _socket!.emit('get_chat_history', {'to': to});
  }

  void disconnect() {
    _socket?.disconnect();
    _socket = null;
  }

  void dispose() {
    _messageController.close();
    _chatHistoryController.close();
    _errorController.close();
    _messageSentController.close();
    disconnect();
  }
}
