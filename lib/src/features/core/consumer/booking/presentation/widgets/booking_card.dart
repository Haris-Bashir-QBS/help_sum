import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/constants/app_dimensions.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/asset_paths.dart';
import 'package:help_sum/src/core/enums/job_status.dart';
import 'package:help_sum/src/core/router/app_routes.dart';
import 'package:help_sum/src/core/utils/app_utils.dart';
import 'package:help_sum/src/features/core/consumer/booking/data/models/job_response_model.dart';
import 'package:help_sum/src/features/core/consumer/booking/presentation/widgets/appointment_date_time_widget.dart';
import 'package:help_sum/src/features/core/merchant/domain/entities/merchant_job_request_resposne_entity.dart';
import 'package:help_sum/src/widgets/custom_text.dart';
import 'package:help_sum/src/widgets/location_timeline.dart';

class BookingCard extends StatelessWidget {
  final JobData job;
  final int index;
  final bool? showStatus;
  final VoidCallback onTap;

  const BookingCard({
    super.key,
    required this.job,
    required this.index,
    required this.onTap,
    this.showStatus,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(color: AppPalette.lightGreyColor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            0.verticalSpace,
            AppointmentDateTimeCard(date: job.date ?? "", time: job.time ?? ""),

            20.verticalSpace,

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingAllSides,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: CustomText(
                      text: job.title,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // CustomText(
                  //   text: '#${job.id}',
                  //   fontSize: 16.sp,
                  //   fontWeight: FontWeight.normal,
                  //   color: AppPalette.hintColor,
                  // ),
                ],
              ),
            ),

            10.verticalSpace,
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingAllSides,
              ),
              child: CustomText(
                text: job.serviceId.name ?? "",
                fontWeight: FontWeight.normal,
                fontSize: 16.sp,
                color: AppPalette.hintColor,
              ),
            ),
            30.verticalSpace,

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: LocationTimeline(
                sourceLocation:
                    "${job.merchantId.location?.address ?? ""},${job.merchantId.location?.city ?? ""},${job.merchantId.location?.state ?? ""}",
                destinationLocation:
                    "${job.location.address ?? ""},${job.location.city ?? ""},${job.location.state ?? ""}",
              ),
            ),
            16.verticalSpace,

            Visibility(
              visible: showStatus == true,
              child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  margin: EdgeInsets.only(right: 12.w),
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 6.w,
                  ),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(-2, 5),
                        spreadRadius: 2,
                        color: AppPalette.greyColor,
                        blurRadius: 5,
                      ),
                    ],
                    color: AppUtils.getJobColor(_parseJobStatus(job.status)),
                    borderRadius: BorderRadius.circular(
                      AppDimensions.appBorderRadius,
                    ),
                  ),
                  child: CustomText(
                    color:
                        _parseJobStatus(job.status) == JobStatus.cancelled
                            ? AppPalette.backgroundColor
                            : null,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.sp,
                    text: AppUtils.getJobString(_parseJobStatus(job.status)),
                  ),
                ),
              ),
            ),

            10.verticalSpace,
          ],
        ),
      ),
    );
  }

  JobStatus _parseJobStatus(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return JobStatus.completed;
      case 'in_progress':
        return JobStatus.in_progress;
      case 'pending':
        return JobStatus.pending;
      case 'accepted':
        return JobStatus.approved;
      case 'confirmation waiting':
        return JobStatus.waitingConfirmation;
      case 'payment waiting':
        return JobStatus.waitingPayment;
      case 'cancelled':
        return JobStatus.cancelled;
      case 'rejected':
        return JobStatus.rejected;
      default:
        return JobStatus.all;
    }
  }
}

class JobCardMerchant extends StatelessWidget {
  final JobData job;
  final int index;
  final bool? showStatus;
  final VoidCallback onTap;

  const JobCardMerchant({
    super.key,
    required this.job,
    required this.index,
    required this.onTap,
    this.showStatus,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppPalette.whiteColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppPalette.lightGreyColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            20.verticalSpace,

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingAllSides,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: CustomText(
                      text: job.title ?? "",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.pushNamed(AppRoutes.chatScreen);
                    },
                    child: CircleAvatar(
                      backgroundColor: AppPalette.primaryGreyColor,
                      child: Image.asset(
                        AppAssets.chatIcon,
                        color: AppPalette.blackColor,
                        width: 24.w,
                        height: 24.h,
                      ),
                    ),
                  ),
                  // CustomText(
                  //   text: '#${job.id}',
                  //   fontSize: 16.sp,
                  //   fontWeight: FontWeight.normal,
                  //   color: AppPalette.hintColor,
                  // ),
                ],
              ),
            ),

            10.verticalSpace,
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingAllSides,
              ),
              child: CustomText(
                text: job.serviceId.name ?? "",
                fontWeight: FontWeight.normal,
                fontSize: 16.sp,
                color: AppPalette.hintColor,
              ),
            ),
            30.verticalSpace,

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: LocationTimeline(
                //sourceLocation: "${job.consumerId.location?.address ?? ""},${job.consumerId.location?.city ?? ""},${job.consumerId.location?.state ?? ""}",
                sourceLocation:
                    "${job.consumerId.location?.address ?? ""},${job.consumerId.location?.city ?? ""},${job.consumerId.location?.state ?? ""}",
                destinationLocation:
                    "${job.location.address} ${job.location.city}${job.location.state}",
              ),
            ),
            16.verticalSpace,

            Visibility(
              visible: showStatus == true,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomText(
                        text: job.date,
                        fontSize: 14.sp,
                        color: AppPalette.secondayColor,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 12.w),
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 6.w,
                      ),
                      decoration: BoxDecoration(
                        color: AppPalette.lightGreyColor,
                        border: Border.all(color: AppPalette.primaryColor),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(2, 2),
                            spreadRadius: 1,
                            color: AppPalette.greyColor.withValues(alpha: .4),
                            blurRadius: 1,
                          ),
                        ],
                        // color: AppUtils.getJobColor(_parseJobStatus(job.status)),
                        borderRadius: BorderRadius.circular(
                          AppDimensions.appBorderRadius,
                        ),
                      ),
                      child: CustomText(
                        color: AppPalette.blackColor,
                        // _parseJobStatus(job.status) == JobStatus.cancelled
                        //     ? AppPalette.backgroundColor
                        //     : null,,
                        fontWeight: FontWeight.bold,

                        fontSize: 13.sp,
                        text: AppUtils.getJobString(
                          _parseJobStatus(job.status),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            10.verticalSpace,
          ],
        ),
      ),
    );
  }

  JobStatus _parseJobStatus(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return JobStatus.completed;
      case 'in_progress':
        return JobStatus.in_progress;
      case 'pending':
        return JobStatus.pending;
      case 'accepted':
        return JobStatus.approved;
      case 'confirmation waiting':
        return JobStatus.waitingConfirmation;
      case 'payment waiting':
        return JobStatus.waitingPayment;
      case 'cancelled':
        return JobStatus.cancelled;
      case 'rejected':
        return JobStatus.rejected;
      default:
        return JobStatus.all;
    }
  }
}
