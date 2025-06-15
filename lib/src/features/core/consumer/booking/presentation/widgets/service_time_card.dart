import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_dimensions.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

class ServiceTimeCard extends StatelessWidget {
  final String title;
  final String date;
  final String time;

  const ServiceTimeCard({
    super.key,
    required this.title,
    required this.date,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingAllSides,
          ).r,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(),
          CustomText(text: title, fontSize: 18.sp, fontWeight: FontWeight.bold),
          Divider(),
          5.verticalSpace,
          CustomText(text: date, fontSize: 16.sp),
          5.verticalSpace,
          CustomText(text: time, fontSize: 16.sp),
        ],
      ),
    );
  }
}
