import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/dependency_injection/di_barrel.dart';
import 'package:help_sum/src/core/router/app_routes.dart';
import 'package:help_sum/src/features/core/common/general/presentation/widgets/notification_list_tile.dart';
import 'package:help_sum/src/features/core/common/notifications/domain/entities/notification_entity.dart';
import 'package:help_sum/src/features/core/common/notifications/presentation/cubit/notification_cubit.dart';
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
  late final NotificationCubit _cubit;

  final jobStatus = [
    'job_created',
    'job_accepted',
    'job_rejected',
    'job_reschedule_request',
    'job_reschedule_response',
    'job_update_request',
    'job_update_response',
    'job_payment',
    'job_cancelled',
    'job_request_extension',
    'job_respond_extension',
    'job_completed',
    'job_cancelled',
  ];

  @override
  void initState() {
    super.initState();
    _cubit = sl<NotificationCubit>();
    _cubit.fetchNotifications();
  }

  @override
  void dispose() {
    _cubit.close(); // 👈 close properly
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit, // 👈 provide cubit
      child: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return _buildShimmer();
          } else if (state is NotificationError) {
            return Center(
              child: CustomText(
                text: state.message,
                fontSize: 14.sp,
                color: Colors.red,
              ),
            );
          } else if (state is NotificationLoaded) {
            if (state.notifications.isEmpty) {
              return _noConversationWidget();
            }

            return Expanded(
              child: CustomRefreshIndicator(
                onRefresh: () async {
                  await _cubit.fetchNotifications(); // 👈 direct use
                },
                child: ListView.separated(
                  padding: EdgeInsets.all(16.w),
                  itemCount: state.notifications.length,
                  separatorBuilder: (_, __) => SizedBox(height: 10.h),
                  itemBuilder: (_, index) {
                    final NotificationEntity n = state.notifications[index];
                    return NotificationListTile(
                      notification: n,
                      onTap: () {
                        log("Type ${n.type}");

                        if (jobStatus.contains(n.type.toLowerCase())) {
                          //Navigate to Job

                          if (n.jobId != null) {
                            context.pushNamed(
                              AppRoutes.bookingTracker,
                              extra: {
                                'job': n.jobId,
                              },
                            );
                          }
                        }
                      },
                    );
                  },
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
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
