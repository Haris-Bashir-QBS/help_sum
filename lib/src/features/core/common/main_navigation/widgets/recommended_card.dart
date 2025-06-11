import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

class RecommendedServiceProviderCard extends StatelessWidget {
  final String title;
  final String reviews;
  final VoidCallback onTap;
  const RecommendedServiceProviderCard({required  this.title, 
    super.key,
    required this.reviews, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:onTap,
      child: Card(
        margin: EdgeInsets.only(right: 10.0.w),
        color: AppPalette.extraLightGreyColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0.r)),
        child: Container(
          width: 150.0.w,
          padding: EdgeInsets.all(10.0.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 24.r,
                backgroundColor: AppPalette.greyColor,
                child: Icon(Icons.person, color: Colors.white, size: 30.w),
              ),
              SizedBox(height: 5.0.h),
              CustomText(text: title, fontWeight: FontWeight.bold, color: AppPalette.darkGreyColor),
              SizedBox(height: 2.0.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 16.w),
                  CustomText(text: reviews, fontSize: 12.sp, color: AppPalette.darkGreyColor),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
} 