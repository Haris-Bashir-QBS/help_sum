import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_dimensions.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/widgets/custom_text.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';

class LocationInfoCard extends StatelessWidget {
  final String locationName;
  final String locationDistance;
  final VoidCallback onDirectionsPressed;
  final VoidCallback onStartPressed;

  const LocationInfoCard({
    super.key,
    required this.locationName,
    required this.locationDistance,
    required this.onDirectionsPressed,
    required this.onStartPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.all(AppDimensions.paddingAllSides.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(
              text: locationName,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
            5.verticalSpace,
            CustomText(
              text: locationDistance,
              fontSize: 16.sp,
              color: AppPalette.orangeColor,
            ),
            15.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onDirectionsPressed,
                    icon: const Icon(
                      Icons.directions,
                      color: AppPalette.primaryColor,
                    ),
                    label: CustomText(
                      text: AppTexts.directions,
                      color: AppPalette.primaryColor,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: BorderSide(color: AppPalette.primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                  ),
                ),
                10.horizontalSpace,
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onStartPressed,
                    icon: const Icon(Icons.near_me, color: Colors.white),
                    label: CustomText(
                      text: AppTexts.startNavigation,
                      color: Colors.white,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppPalette.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
