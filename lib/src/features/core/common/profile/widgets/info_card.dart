import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final VoidCallback onPressed;

  const InfoCard({
    super.key,
    required this.title,
    required this.children,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           CustomText(
                    text: title,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  8.verticalSpace,
          Container(
            width: 1.sw,
            padding: EdgeInsets.only(left: 22.w,top: 22.h,bottom: 22.h,right: 22.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppPalette.lightGreyColor,
              border: Border.all(color: AppPalette.greyColor)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:  children,
              
            ),
          ),
        ],
      ),
    );
  }
} 