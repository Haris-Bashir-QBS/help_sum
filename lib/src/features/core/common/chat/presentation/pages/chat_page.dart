import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/dependency_injection/di_barrel.dart';
import 'package:help_sum/src/core/enums/message_type.dart';
import 'package:help_sum/src/core/services/local_storage_service.dart';
import 'package:help_sum/src/core/utils/time_utils.dart';
import 'package:help_sum/src/features/core/common/chat/domain/entities/inbox_chat_entity.dart';
import 'package:help_sum/src/features/core/common/chat/presentation/bloc/chat_bloc.dart';
import 'package:help_sum/src/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:help_sum/src/features/core/common/chat/widgets/chat_bubble.dart';
import 'package:help_sum/src/features/core/common/chat/widgets/chat_input_field.dart';
import 'package:help_sum/src/features/core/common/chat/widgets/message_shimmer.dart';
import 'package:help_sum/src/widgets/custom_text.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';

class ChatScreen extends StatefulWidget {
  final InboxChatEntity user;

  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final ChatBloc _chatBloc;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _chatBloc = ChatBloc(
      chatRepository: sl(),
      getInboxChatsUseCase: sl(),
      sendMessageUseCase: sl(),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final token = LocalStorageService().getAccessToken();
      if (token != null && token.isNotEmpty) {
        _chatBloc.add(const ClearMessages());
        _chatBloc.add(ConnectSocket(token: token));
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (!_isDisposed && !_chatBloc.isClosed) {
            _chatBloc.add(LoadChatHistory(to: widget.user.userId));
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _chatBloc),
        BlocProvider.value(value: sl<LoginBloc>()),
      ],
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, size: 24.sp),
            color: Colors.white,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Row(
            children: [
              CircleAvatar(
                radius: 18.r,
                backgroundImage:
                    widget.user.image != null
                        ? NetworkImage(widget.user.image!)
                        : null,
                child:
                    widget.user.image == null
                        ? Icon(Icons.person, size: 18.sp, color: Colors.white)
                        : null,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: CustomText(
                  text: (widget.user.firstName + widget.user.lastName),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          backgroundColor: AppPalette.primaryColor,
          foregroundColor: Colors.white,
        ),
        body: BlocConsumer<ChatBloc, ChatState>(
          listener: (context, state) {
            if (state.errorMessage.isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
                  backgroundColor: Colors.red,
                ),
              );
            }

            if (state.messages.isNotEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (_scrollController.hasClients) {
                  _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                }
              });
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                Expanded(
                  child:
                      state.isLoadingMessages
                          ? const MessageShimmer()
                          : state.messages.isEmpty
                          ? _noMessages()
                          : _messagesListView(state),
                ),
                _textField(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _textField() {
    return ChatInputField(
      controller: _messageController,
      onSend: () {
        if (_messageController.text.trim().isNotEmpty &&
            !_isDisposed &&
            !_chatBloc.isClosed) {
          _chatBloc.add(
            SendMessage(
              receiverId: widget.user.userId,
              message: _messageController.text.trim(),
              type: MessageType.text.name,
            ),
          );
          _messageController.clear();
        }
      },
    );
  }

  ListView _messagesListView(ChatState state) {
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.all(16.w),
      itemCount: state.messages.length,
      itemBuilder: (context, index) {
        final message = state.messages[index];
        final currentUserId = context.read<LoginBloc>().state.userEntity?.id;
        final isOwnMessage = message.senderId == currentUserId;
        return Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: ChatBubble(
            text: message.message,
            isMe: isOwnMessage,
            time: TimeUtils.formatChatTime(message.createdAt),
            type: message.type,
            mediaUrl: message.mediaUrl,
          ),
        );
      },
    );
  }

  Center _noMessages() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline, size: 64.sp, color: Colors.grey[400]),
          SizedBox(height: 16.h),
          CustomText(
            text: 'No messages yet',
            fontSize: 16.sp,
            color: Colors.grey[600],
          ),
          SizedBox(height: 8.h),
          CustomText(
            text: 'Start the conversation!',
            fontSize: 14.sp,
            color: Colors.grey[500],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _isDisposed = true;
    _messageController.dispose();
    _scrollController.dispose();
    if (!_chatBloc.isClosed) {
      _chatBloc.add(const DisconnectSocket());
    }
    _chatBloc.close();
    super.dispose();
  }
}
