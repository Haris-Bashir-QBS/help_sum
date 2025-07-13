import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

class RecommendedServiceProviderCard extends StatelessWidget {
  final String name;
  final String rating;
  final String distance;
  final String pricePerHour;
  final String imageUrl;
  final VoidCallback onTap;

  const RecommendedServiceProviderCard({
    super.key,
    required this.name,
    required this.rating,
    required this.distance,
    required this.pricePerHour,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 270.w,
        margin: EdgeInsets.only(right: 0.w),
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Align(
          alignment: Alignment.center,
          child: Row(
            children: [
              Align(
                alignment: Alignment.center,
                child: CircleAvatar(
                  radius: 30.r,
                  backgroundImage: NetworkImage(imageUrl),
                ),
              ),
              8.horizontalSpace,
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: name,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  4.verticalSpace,
                  Row(
                    children: [
                      Icon(Icons.star, color: AppPalette.starColor, size: 16.w),
                      4.horizontalSpace,
                      CustomText(
                        text: rating,
                        fontSize: 12.sp,
                        color: AppPalette.blackColor,
                      ),
                    ],
                  ),
                  4.verticalSpace,
                  CustomText(
                    text: distance,
                    fontSize: 12.sp,
                    color: AppPalette.greyColor,
                  ),
                  4.verticalSpace,
                  CustomText(
                    text: pricePerHour,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: AppPalette.blackColor,
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
