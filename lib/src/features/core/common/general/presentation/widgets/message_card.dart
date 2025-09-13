import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

class ContentCard extends StatelessWidget {
  final String name;
  final String message;
  final String time;
  final int unreadCount;
  final String? avatarUrl;
  final VoidCallback? onTap;

  const ContentCard({
    super.key,
    required this.name,
    required this.message,
    required this.time,
    this.unreadCount = 0,
    this.avatarUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      // borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 5.w),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              color: AppPalette.secondayColor.withValues(alpha: .2),
            ),
          ),
          // borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Avatar
            if (avatarUrl != null) ...[
              CircleAvatar(
                radius: 30.r,
                backgroundColor: Colors.grey.shade300,
                backgroundImage:
                    avatarUrl != null ? NetworkImage(avatarUrl!) : null,
              ),
              SizedBox(width: 12.w),
            ],

            // Name + Message
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: name,
                    fontWeight: FontWeight.w600,
                    fontSize: 15.sp,
                    // style: TextStyle(
                    //   fontSize: 14.sp,
                    //   fontWeight: FontWeight.w600,
                    // ),
                  ),
                  SizedBox(height: 4.h),
                  CustomText(
                    text: message,
                    maxLines: 2,
                    fontSize: 14.sp,
                    color: AppPalette.hintColor,
                  ),
                ],
              ),
            ),

            SizedBox(width: 8.w),

            // Time + Unread badge
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CustomText(
                  text: time,
                  fontSize: 11.sp,
                  color: AppPalette.secondayColor,
                ),
                SizedBox(height: 6.h),
                if (unreadCount > 0)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppPalette.primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      unreadCount.toString(),
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
