import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

class InvoiceLabelWidget extends StatelessWidget {
  final String name;
  const InvoiceLabelWidget({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      padding: EdgeInsets.symmetric(vertical: 17.h),
      decoration: BoxDecoration(color: AppPalette.lightBlueColor),
      child: Center(
        child: CustomText(
          text: "Invoice for $name",
          fontSize: 18.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
