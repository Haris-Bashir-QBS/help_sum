import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

class AppointmentDateTimeCard extends StatelessWidget {
  final String date;
  final String time;
  final bool isSelected;
  final VoidCallback? onTap;

  const AppointmentDateTimeCard({
    super.key,
    required this.date,
    required this.time,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      width: 1.sw,
      decoration: BoxDecoration(color: Color(0xFFD9D9D9)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CustomText(text: AppTexts.date, fontWeight: FontWeight.bold),
          CustomText(text: date, fontWeight: FontWeight.normal),
          CustomText(text: AppTexts.time, fontWeight: FontWeight.bold),
          CustomText(
            textAlign: TextAlign.end,
            text: time,
            fontWeight: FontWeight.normal,
          ),
        ],
      ),
    );
  }
}
