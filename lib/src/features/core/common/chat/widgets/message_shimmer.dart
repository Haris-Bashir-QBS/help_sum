import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';

class MessageShimmer extends StatelessWidget {
  const MessageShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: 6, // Show 6 shimmer message bubbles
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: _buildShimmerBubble(index),
        );
      },
    );
  }

  Widget _buildShimmerBubble(int index) {
    // Alternate between left and right alignment for variety
    final isMe = index % 2 == 0;
    
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            // Message bubble shimmer
            Container(
              constraints: BoxConstraints(
                maxWidth: 250.w,
                minWidth: 100.w,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 10.h,
              ),
              decoration: BoxDecoration(
                color: isMe ? AppPalette.orangeColor : AppPalette.primaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.r),
                  topRight: Radius.circular(12.r),
                  bottomLeft: isMe ? Radius.circular(12.r) : Radius.circular(4.r),
                  bottomRight: isMe ? Radius.circular(4.r) : Radius.circular(12.r),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // First line of message
                  Container(
                    width: double.infinity,
                    height: 14.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  // Second line of message (shorter)
                  Container(
                    width: 120.w,
                    height: 14.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 4.h),
            // Time shimmer
            Container(
              width: 40.w,
              height: 12.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
