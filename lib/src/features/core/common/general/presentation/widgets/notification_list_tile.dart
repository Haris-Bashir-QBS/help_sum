import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/features/core/common/notifications/domain/entities/notification_entity.dart';
import 'package:intl/intl.dart';

import '../../../../../../core/constants/app_palette.dart';

class NotificationListTile extends StatelessWidget {
  final NotificationEntity notification;
  final VoidCallback? onTap;
  final bool isUnread;

  const NotificationListTile({
    super.key,
    required this.notification,
    this.onTap,
    this.isUnread = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color:
              isUnread
                  ? AppPalette.primaryColor.withOpacity(0.08)
                  : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Leading icon
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: AppPalette.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications,
                color: AppPalette.primaryColor,
              ),
            ),
            SizedBox(width: 12.w),

            // Title & body
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    notification.body,
                    style: TextStyle(fontSize: 13.sp, color: Colors.grey[700]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Timestamp
            Padding(
              padding: EdgeInsets.only(left: 8.w, top: 2.h),
              child: Text(
                _formatDate(notification.createdAt),
                style: TextStyle(fontSize: 11.sp, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final localDate = date.toLocal();
    final now = DateTime.now();
    final difference = now.difference(localDate);

    if (difference.inDays == 0) {
      return DateFormat('hh:mm a').format(localDate); // Today
    } else if (difference.inDays == 1) {
      return "Yesterday";
    } else {
      return DateFormat('dd/MM/yyyy').format(localDate); // Full date
    }
  }
}
