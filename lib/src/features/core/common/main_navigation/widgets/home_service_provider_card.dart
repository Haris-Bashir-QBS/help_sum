import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

class HomeServiceProviderCard extends StatelessWidget {
  final String title;
  final String rating;
  final String reviews;
  final VoidCallback onTap;

  const HomeServiceProviderCard({
    super.key,
    required this.title,
    required this.reviews,
    required this.onTap,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Color(0xFFF7F7F7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0.r),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 30.r,
                backgroundColor: AppPalette.greyColor,
                child: Icon(Icons.person, color: Colors.white, size: 30.w),
              ),
              SizedBox(height: 5.0.h),
              CustomText(
                text: title,
                fontWeight: FontWeight.bold,
                color: AppPalette.darkGreyColor,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 2.0.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 16.w),
                  CustomText(
                    text: rating,
                    fontSize: 12.sp,
                    color: AppPalette.darkGreyColor,
                    textAlign: TextAlign.center,
                  ),
                  5.horizontalSpace,
                  CustomText(
                    text: "($reviews Reviews)",
                    fontSize: 12.sp,
                    color: AppPalette.darkGreyColor,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
