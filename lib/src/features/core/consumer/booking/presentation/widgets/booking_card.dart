import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/constants/app_dimensions.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/asset_paths.dart';
import 'package:help_sum/src/core/enums/job_status.dart';
import 'package:help_sum/src/core/router/app_routes.dart';
import 'package:help_sum/src/core/utils/app_utils.dart';
import 'package:help_sum/src/features/core/common/chat/domain/entities/inbox_chat_entity.dart';
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
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        elevation: 4,
        margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
        shadowColor: Colors.black26,
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppointmentDateTimeCard(
                date: job.date ?? "",
                time: job.time ?? "",
              ),
              16.verticalSpace,
              Text(
                job.title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[900],
                ),
              ),
              4.verticalSpace,
              Text(
                job.serviceId.name ?? "",
                style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
              ),
              16.verticalSpace,
              LocationTimeline(
                sourceLocation:
                    "${job.merchantId.location?.address ?? ""}, ${job.merchantId.location?.city ?? ""}, ${job.merchantId.location?.state ?? ""}",
                destinationLocation:
                    "${job.location.address ?? ""}, ${job.location.city ?? ""}, ${job.location.state ?? ""}",
              ),
              16.verticalSpace,
              if (showStatus == true)
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      gradient: LinearGradient(
                        colors: _getStatusGradient(_parseJobStatus(job.status)),
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      AppUtils.getJobString(_parseJobStatus(job.status)),
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
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

  List<Color> _getStatusGradient(JobStatus status) {
    switch (status) {
      case JobStatus.completed:
        return [Colors.green.shade400, Colors.green.shade700];
      case JobStatus.in_progress:
        return [Colors.blue.shade400, Colors.blue.shade700];
      case JobStatus.pending:
      case JobStatus.waitingConfirmation:
      case JobStatus.waitingPayment:
        return [Colors.orange.shade400, Colors.orange.shade700];
      case JobStatus.cancelled:
      case JobStatus.rejected:
        return [Colors.red.shade400, Colors.red.shade700];
      default:
        return [Colors.grey.shade400, Colors.grey.shade600];
    }
  }
}

// -------------------------- JobCardMerchant -------------------------- //

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
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        elevation: 4,
        margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
        shadowColor: Colors.black26,
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      job.title ?? "",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[900],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.pushNamed(
                        AppRoutes.chatScreen,
                        extra: InboxChatEntity(
                          userId: job.merchantId.id ?? "",
                          firstName: job.merchantId.firstName,
                          lastName: job.merchantId.lastName,
                          image: job.merchantId.image,
                        ),
                      );
                    },
                    child: CircleAvatar(
                      radius: 20.r,
                      backgroundColor: AppPalette.primaryGreyColor,
                      child: Image.asset(
                        AppAssets.chatIcon,
                        width: 24.w,
                        height: 24.h,
                        color: AppPalette.blackColor,
                      ),
                    ),
                  ),
                ],
              ),
              4.verticalSpace,
              Text(
                job.serviceId.name ?? "",
                style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
              ),
              16.verticalSpace,
              LocationTimeline(
                sourceLocation:
                    "${job.consumerId.location?.address ?? ""}, ${job.consumerId.location?.city ?? ""}, ${job.consumerId.location?.state ?? ""}",
                destinationLocation:
                    "${job.location.address ?? ""}, ${job.location.city ?? ""}, ${job.location.state ?? ""}",
              ),
              16.verticalSpace,
              if (showStatus == true)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      job.date ?? "",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppPalette.secondayColor,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        gradient: LinearGradient(
                          colors: _getStatusGradient(
                            _parseJobStatus(job.status),
                          ),
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        AppUtils.getJobString(_parseJobStatus(job.status)),
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
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

  List<Color> _getStatusGradient(JobStatus status) {
    switch (status) {
      case JobStatus.completed:
        return [Colors.green.shade400, Colors.green.shade700];
      case JobStatus.in_progress:
        return [Colors.blue.shade400, Colors.blue.shade700];
      case JobStatus.pending:
      case JobStatus.waitingConfirmation:
      case JobStatus.waitingPayment:
        return [Colors.orange.shade400, Colors.orange.shade700];
      case JobStatus.cancelled:
      case JobStatus.rejected:
        return [Colors.red.shade400, Colors.red.shade700];
      default:
        return [Colors.grey.shade400, Colors.grey.shade600];
    }
  }
}
