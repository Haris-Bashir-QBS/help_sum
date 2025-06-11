import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/router/app_routes.dart';
import 'package:help_sum/src/core/utils/app_static_data.dart';
import 'package:help_sum/src/widgets/custom_text.dart';
import 'package:help_sum/src/widgets/image_view.dart';

class RecommendedCard extends StatelessWidget {
  final String imagePath;
  final String name;
  final String profession;
  final double rating;
  final int reviewsCount;
  final double distance;
  final String distanceLabel;

  const RecommendedCard({
    super.key,
    required this.imagePath,
    required this.name,
    required this.profession,
    required this.rating,
    required this.reviewsCount,
    required this.distance,
    required this.distanceLabel,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Find the service provider from AppStaticData
        final serviceProvider = AppStaticData.serviceProviders.firstWhere(
          (provider) => provider.name == name,
          orElse: () => AppStaticData.serviceProviders.first,
        );
        context.pushNamed(
          AppRoutes.merchantProfile,
          extra: serviceProvider,
        );
      },
      child: Container(
        width: 200.w,
        margin: EdgeInsets.only(right: 10.w),
        decoration: BoxDecoration(
          color: AppPalette.extraLightGreyColor,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10.r)),
              child: ImageView(
                imagePath: imagePath,
                height: 120.h,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: name,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(height: 5.h),
                  CustomText(
                    text: profession,
                    fontSize: 14.sp,
                    color: AppPalette.darkGreyColor,
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Icon(
                        Icons.star_rounded,
                        color: AppPalette.starColor,
                        size: 16.sp,
                      ),
                      SizedBox(width: 5.w),
                      CustomText(
                        text: rating.toStringAsFixed(1),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(width: 5.w),
                      CustomText(
                        text: '(${reviewsCount})',
                        fontSize: 12.sp,
                        color: AppPalette.darkGreyColor,
                      ),
                      const Spacer(),
                      Icon(
                        Icons.location_on,
                        color: AppPalette.darkGreyColor,
                        size: 16.sp,
                      ),
                      SizedBox(width: 5.w),
                      CustomText(
                        text: '$distance $distanceLabel',
                        fontSize: 12.sp,
                        color: AppPalette.darkGreyColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 