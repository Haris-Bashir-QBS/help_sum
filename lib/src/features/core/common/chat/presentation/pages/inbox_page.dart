import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/dependency_injection/di_barrel.dart';
import 'package:help_sum/src/core/services/local_storage_service.dart';
import 'package:help_sum/src/core/utils/time_utils.dart';
import 'package:help_sum/src/features/core/common/chat/domain/entities/inbox_chat_entity.dart';
import 'package:help_sum/src/features/core/common/chat/presentation/bloc/chat_bloc.dart';
import 'package:help_sum/src/features/core/common/chat/presentation/widgets/inbox_shimmer.dart';
import 'package:help_sum/src/widgets/custom_refresh_indicator.dart';
import 'package:help_sum/src/widgets/custom_text.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/router/app_routes.dart';
import 'package:hugeicons/hugeicons.dart';

class InboxPage extends StatefulWidget {
  const InboxPage({super.key});

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  late final ChatBloc _chatBloc;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    // Create a new ChatBloc instance instead of using singleton
    _chatBloc = ChatBloc(
      chatRepository: sl(),
      getInboxChatsUseCase: sl(),
      sendMessageUseCase: sl(),
    );

    // Load inbox chats when entering inbox (no socket connection needed here)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _chatBloc.add(const LoadInboxChats());
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    // Close the bloc when leaving inbox (no socket to disconnect)
    _chatBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _chatBloc,
      child: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state.errorMessage.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          // Load inbox chats when connected
          if (state.isConnected &&
              state.inboxChats.isEmpty &&
              !state.isLoadingInbox) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<ChatBloc>().add(const LoadInboxChats());
            });
          }

          if (state.isLoadingInbox) {
            return const InboxShimmer();
          }

          if (state.inboxChats.isEmpty) {
            return _noConversationWidget();
          }

          return Expanded(
            child: CustomRefreshIndicator(
              onRefresh: () async {
                context.read<ChatBloc>().add(const LoadInboxChats());
              },
              child: ListView.separated(
                padding: EdgeInsets.all(16.w),
                itemBuilder: (context, index) {
                  final chat = state.inboxChats[index];
                  return _buildChatItem(chat);
                },
                separatorBuilder: (_, index) {
                  return SizedBox(height: 12.h);
                },
                itemCount: state.inboxChats.length,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _noConversationWidget() {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 250.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HugeIcon(
              icon: HugeIcons.strokeRoundedBubbleChat,
              size: 64.sp,
              color: AppPalette.primaryColor,
            ),
            SizedBox(height: 16.h),
            CustomText(
              text: 'No conversations yet',
              fontSize: 16.sp,
              color: AppPalette.primaryColor,
            ),
            SizedBox(height: 8.h),
            CustomText(
              text: 'Start a conversation with someone',
              fontSize: 14.sp,
              color: AppPalette.primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatItem(InboxChatEntity chat) {
    final lastMessage = chat.lastMessage;
    final time = lastMessage?.createdAt ?? DateTime.now();

    return GestureDetector(
      onTap: () {
        // Navigate to chat screen
        context.pushNamed(AppRoutes.chatScreen, extra: chat);
      },
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: AppPalette.whiteColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppPalette.lightGreyColor),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25.r,
              backgroundImage:
                  chat.image != null ? NetworkImage(chat.image!) : null,
              child:
                  chat.image == null
                      ? Icon(
                        Icons.person,
                        size: 24.sp,
                        color: AppPalette.primaryColor,
                      )
                      : null,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomText(
                          text: '${chat.firstName} ${chat.lastName}',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          maxLines: 1,
                        ),
                      ),
                      CustomText(
                        text: TimeUtils.formatRelativeTime(time),
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Expanded(
                        child: CustomText(
                          text: lastMessage?.message ?? 'No messages yet',
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                          maxLines: 1,
                        ),
                      ),
                      // if (chat.unreadCount > 0) ...[
                      //   SizedBox(width: 8.w),
                      //   Container(
                      //     padding: EdgeInsets.symmetric(
                      //       horizontal: 8.w,
                      //       vertical: 4.h,
                      //     ),
                      //     decoration: BoxDecoration(
                      //       color: AppPalette.primaryColor,
                      //       borderRadius: BorderRadius.circular(12.r),
                      //     ),
                      //     child: CustomText(
                      //       text: chat.unreadCount.toString(),
                      //       fontSize: 12.sp,
                      //       color: Colors.white,
                      //       fontWeight: FontWeight.w600,
                      //     ),
                      //   ),
                      // ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
