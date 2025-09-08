// ignore_for_file: use_super_parameters
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/utils/app_utils.dart';
import 'package:help_sum/src/widgets/custom_text.dart';
import 'package:help_sum/src/features/core/consumer/booking/data/models/job_response_model.dart';
import 'package:help_sum/src/core/enums/job_status.dart';

class RichBookingCard extends StatelessWidget {
  final JobData job;
  final VoidCallback onTap;
  final bool showStatus;
  final bool? isMerchant;
  const RichBookingCard({
    Key? key,
    required this.job,
    required this.onTap,
    this.showStatus = true,
    this.isMerchant,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Service Title
            CustomText(
              text: job.title,
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
              maxLines: 1,
            ),

            6.verticalSpace,
            // 🔹 Description
            CustomText(
              text: job.description,
              fontSize: 13.sp,
              color: AppPalette.hintColor,
              maxLines: 2,
            ),
            10.verticalSpace,
            // 🔹 Service chip (service name)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppPalette.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: CustomText(
                text: job.serviceId.name ?? "Service",
                fontSize: 11.sp,
                color: AppPalette.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),

            12.verticalSpace,

            // 🔹 Location
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 18.sp,
                  color: AppPalette.primaryColor,
                ),
                6.horizontalSpace,
                Expanded(
                  child: CustomText(
                    text:
                        "${job.location.address}, ${job.location.city}, ${job.location.state}",
                    fontSize: 13.sp,
                    maxLines: 1,
                  ),
                ),
              ],
            ),

            16.verticalSpace,

            // 🔹 Inline info row (Date • Time • Duration • Offer)
            Row(
              children: [
                _infoItem(Icons.calendar_today_outlined, job.date),
                _dotDivider(),
                _infoItem(Icons.access_time_outlined, job.time),
                _dotDivider(),
                _infoItem(Icons.schedule, "${job.estimatedWorkTime} hr"),
                _dotDivider(),
                _infoItem(Icons.attach_money, "${job.offer}", highlight: true),
              ],
            ),

            Divider(height: 28.h, thickness: 0.8, color: Colors.grey[200]),

            // 🔹 Merchant Info + Status
            ProfileAvatarWithName(
              isMerchant: isMerchant == true,
              firstName:
                  isMerchant == true
                      ? job.consumerId.firstName
                      : job.merchantId.firstName,
              lastName:
                  isMerchant == true
                      ? job.consumerId.lastName
                      : job.merchantId.lastName,
              imageUrl:
                  isMerchant == true
                      ? job.consumerId.image
                      : job.merchantId.image,
              rating:
                  isMerchant == true
                      ? job.consumerId.averageRating
                      : job.merchantId.averageRating,
              reviewCount:
                  isMerchant == true
                      ? job.consumerId.reviewCount
                      : job.merchantId.reviewCount,
            ),

            if (showStatus) ...[
              2.verticalSpace,
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppUtils.getJobColor(
                      _parseJobStatus(job.status),
                    ).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: AppUtils.getJobColor(_parseJobStatus(job.status)),
                    ),
                  ),
                  child: CustomText(
                    text: AppUtils.getJobString(_parseJobStatus(job.status)),
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                    color: AppUtils.getJobColor(_parseJobStatus(job.status)),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Inline info item
  Widget _infoItem(IconData icon, String value, {bool highlight = false}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16.sp,
          color: highlight ? Colors.green : AppPalette.primaryColor,
        ),
        4.horizontalSpace,
        CustomText(
          text: value,
          fontSize: 12.sp,
          fontWeight: highlight ? FontWeight.bold : FontWeight.w500,
          color: highlight ? Colors.green.shade700 : Colors.black,
        ),
      ],
    );
  }

  /// Dot separator
  Widget _dotDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Text("•", style: TextStyle(fontSize: 16.sp, color: Colors.grey)),
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

class ProfileAvatarWithName extends StatelessWidget {
  final bool isMerchant;
  final String? imageUrl;
  final String firstName;
  final String lastName;
  final String? rating;
  final String? reviewCount;

  const ProfileAvatarWithName({
    Key? key,
    required this.isMerchant,
    required this.firstName,
    required this.lastName,
    this.imageUrl,
    this.rating,
    this.reviewCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("Image URL: $imageUrl");

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start, // 👈 keep text top aligned
      children: [
        CircleAvatar(
          radius: 18.r,
          backgroundColor: AppPalette.lightGreyColor,

          backgroundImage:
              (imageUrl?.isNotEmpty == true) ? NetworkImage(imageUrl!) : null,

          child:
              (imageUrl == null || imageUrl!.isEmpty)
                  ? Icon(Icons.person, size: 18.sp, color: Colors.white)
                  : null,
        ),
        10.horizontalSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: "$firstName $lastName",
                fontWeight: FontWeight.w600,
                fontSize: 13.sp,
              ),
              if (rating != null) ...[
                4.verticalSpace,
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 14.sp),
                    4.horizontalSpace,
                    CustomText(
                      text: rating ?? "",
                      fontSize: 12.sp,
                      color: Colors.grey,
                    ),
                    CustomText(
                      text: " (${reviewCount ?? "0"})",
                      fontSize: 12.sp,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
