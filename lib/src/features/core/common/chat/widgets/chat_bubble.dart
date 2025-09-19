import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/widgets/custom_text.dart';
import 'package:help_sum/src/features/core/common/chat/widgets/chat_bubble_clipper.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isMe;
  final String? time;
  final String? type;
  final String? mediaUrl;

  const ChatBubble({
    super.key,
    required this.text,
    required this.isMe,
    this.time,
    this.type,
    this.mediaUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Bubble(
            color: isMe ? AppPalette.orangeColor : AppPalette.primaryColor,
            nip: isMe ? BubbleNip.rightTop : BubbleNip.leftTop,
            nipWidth: 8.w,
            nipHeight: 10.h,
            nipRadius: 1.r,
            radius: Radius.circular(12.r),
            padding: BubbleEdges.only(
              left: 16.w,
              right: 16.w,
              top: 10.h,
              bottom: 10.h,
            ),
            margin: BubbleEdges.only(
              left: isMe ? 40.w : 0,
              right: isMe ? 0 : 40.w,
            ),
            child: _buildMessageContent(),
          ),
          if (time != null) ...[
            SizedBox(height: 4.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: CustomText(
                text: time!,
                fontSize: 12.sp,
                color: Colors.grey[600],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageContent() {
    if (type == 'media' && mediaUrl != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Image.network(
              mediaUrl!,
              width: 200.w,
              height: 150.h,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 200.w,
                  height: 150.h,
                  color: Colors.grey[300],
                  child: Icon(Icons.broken_image, color: Colors.grey[600]),
                );
              },
            ),
          ),
          if (text.isNotEmpty) ...[
            SizedBox(height: 8.h),
            CustomText(
              text: text,
              color: Colors.white,
              fontSize: 14.sp,
              maxLines: 10000000,
            ),
          ],
        ],
      );
    } else {
      return CustomText(
        text: text,
        color: Colors.white,
        fontSize: 14.sp,
        maxLines: 10000,
      );
    }
  }
}
