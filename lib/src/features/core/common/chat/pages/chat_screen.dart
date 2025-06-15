import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_dimensions.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/widgets/custom_app_bar.dart';
import 'package:help_sum/src/widgets/custom_text.dart';
import 'package:help_sum/src/features/core/common/chat/widgets/chat_bubble.dart';
import 'package:help_sum/src/features/core/common/chat/widgets/chat_input_field.dart';
import 'package:help_sum/src/features/core/common/chat/domain/models/chat_message.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [
    ChatMessage(
      key: GlobalKey(),
      sender: 'M',
      text: 'At what time you will reach?',
      isMe: false,
      seen: true,
    ),
    ChatMessage(
      key: GlobalKey(),
      sender: 'U',
      text: 'I will be there in 15 minutes',
      isMe: true,
      seen: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: const CustomAppBar(
        title: 'Online',
        centerTitle: true,
        showLeading: true,
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          ChatInputField(controller: _messageController, onSend: _sendMessage),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.all(AppDimensions.paddingAllSides.w),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        return _buildMessageItem(message);
      },
    );
  }

  Widget _buildMessageItem(ChatMessage message) {
    return Align(
      key: message.key,
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          _buildMessageRow(message),
          if (message.seen && message.isMe) _buildSeenIndicator(),
          10.verticalSpace,
        ],
      ),
    );
  }

  Widget _buildMessageRow(ChatMessage message) {
    return Row(
      mainAxisAlignment:
          message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!message.isMe)
          _buildAvatar(message.sender, AppPalette.primaryColor),
        10.horizontalSpace,
        ChatBubble(text: message.text, isMe: message.isMe),
        10.horizontalSpace,
        if (message.isMe) _buildAvatar(message.sender, AppPalette.orangeColor),
      ],
    );
  }

  Widget _buildAvatar(String text, Color backgroundColor) {
    return CircleAvatar(
      backgroundColor: backgroundColor,
      child: CustomText(text: text, color: Colors.white),
    );
  }

  Widget _buildSeenIndicator() {
    return Padding(
      padding: EdgeInsets.only(top: 4.h, left: 40.w),
      child: CustomText(
        text: AppTexts.seen,
        color: AppPalette.orangeColor,
        fontSize: 12.sp,
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      _addNewMessage();
      _addDummyResponse();
      _messageController.clear();
    }
  }

  void _addNewMessage() {
    final newMessage = ChatMessage(
      key: GlobalKey(),
      sender: 'U',
      text: _messageController.text,
      isMe: true,
      seen: false,
    );
    setState(() {
      _messages.add(newMessage);
    });
    _scrollToMessage(newMessage);
  }

  void _addDummyResponse() {
    Future.delayed(const Duration(milliseconds: 100), () {
      final dummyResponse = ChatMessage(
        key: GlobalKey(),
        sender: 'M',
        text: 'Okay, got it!',
        isMe: false,
        seen: true,
      );
      setState(() {
        _messages.add(dummyResponse);
      });
      _scrollToMessage(dummyResponse);
    });
  }

  void _scrollToMessage(ChatMessage message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (message.key!.currentContext != null) {
        Scrollable.ensureVisible(
          message.key!.currentContext!,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          alignment: 1.0,
        );
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
