import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_dimensions.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/enums/job_status.dart';
import 'package:help_sum/src/core/utils/app_utils.dart';
import 'package:help_sum/src/features/core/common/main_navigation/domain/model/job_model.dart';
import 'package:help_sum/src/features/core/consumer/booking/presentation/widgets/appointment_date_time_widget.dart';
import 'package:help_sum/src/widgets/custom_text.dart';
import 'package:help_sum/src/widgets/location_timeline.dart';

class BookingCard extends StatelessWidget {
  final JobModel job;
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
            AppointmentDateTimeCard(date: job.date, time: job.time),

            20.verticalSpace,

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingAllSides,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: CustomText(
                      text: job.customerName,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  CustomText(
                    text: '#${index + 2}',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.normal,
                    color: AppPalette.hintColor,
                  ),
                ],
              ),
            ),

            10.verticalSpace,
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingAllSides,
              ),
              child: CustomText(
                text: job.serviceName,
                fontWeight: FontWeight.normal,
                fontSize: 16.sp,
                color: AppPalette.hintColor,
              ),
            ),
            30.verticalSpace,

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: LocationTimeline(),
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
                    color: AppUtils.getJobColor(job.status),
                    borderRadius: BorderRadius.circular(
                      AppDimensions.appBorderRadius,
                    ),
                  ),
                  child: CustomText(
                    color:
                        job.status == JobStatus.cancelled
                            ? AppPalette.backgroundColor
                            : null,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.sp,
                    text: AppUtils.getJobString(job.status),
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
}
