import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/features/core/common/general/presentation/widgets/message_card.dart';
import 'package:help_sum/src/widgets/custom_refresh_indicator.dart';
import 'package:help_sum/src/widgets/custom_text.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../../core/constants/app_palette.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool _isLoading = true;
  

  @override
  void initState() {
    super.initState();
    // Simulate shimmer for 1 second
    Timer(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildShimmer();
    } else {
      return _noConversationWidget();
    }
  }

  Widget _buildShimmer() {
    return Expanded(
      child: ListView.separated(
        padding: EdgeInsets.all(16.w),
        itemCount: 10,
        separatorBuilder: (_, __) => SizedBox(height: 10.h),
        itemBuilder: (_, __) {
          return Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar Circle
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                // Title + Message
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title line
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          height: 14.h,
                          width: 120.w,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      // Message line
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          height: 12.h,
                          width: double.infinity,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                // Timestamp
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 12.h,
                    width: 40.w,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _noConversationWidget() {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 270.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HugeIcon(
              icon: HugeIcons.strokeRoundedNotification01,
              size: 64.sp,
              color: AppPalette.primaryColor,
            ),
            SizedBox(height: 16.h),
            CustomText(
              text: 'No Notifications Found',
              fontSize: 16.sp,
              color: AppPalette.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
