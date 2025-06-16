import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/widgets/custom_text.dart';
import 'package:help_sum/src/features/core/common/chat/widgets/chat_bubble_clipper.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isMe;

  const ChatBubble({super.key, required this.text, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Bubble(
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
      margin: BubbleEdges.only(left: isMe ? 40.w : 0, right: isMe ? 0 : 40.w),
      child: CustomText(text: text, color: Colors.white, fontSize: 14.sp),
    );
  }
}
