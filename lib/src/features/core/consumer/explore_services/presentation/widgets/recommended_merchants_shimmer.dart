import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:skeletonizer/skeletonizer.dart';

class RecommendedMerchantsShimmer extends StatelessWidget {
  const RecommendedMerchantsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        itemBuilder:
            (context, index) => Skeletonizer(
              enabled: true,
              child: Container(
                width: 180.w,
                margin: EdgeInsets.symmetric(vertical: 8.h),
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: AppPalette.primaryColor.withAlpha(190),
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Skeleton.shade(
                      child: Container(
                        height: 52.h,
                        width: 50.w,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          shape: BoxShape.circle,
                        ),
                        // decoration: BoxDecoration(
                        //   color: Colors.grey[100],
                        //   shape: BoxShape.circle,
                        // ),
                      ),
                    ),
                    16.verticalSpace,
                    Container(
                      height: 12.h,
                      width: 100.w,
                      color: Colors.grey[300],
                    ),
                    8.verticalSpace,
                    Container(
                      height: 12.h,
                      width: 60.w,
                      color: Colors.grey[300],
                    ),
                  ],
                ),
              ),
            ),
        separatorBuilder: (context, index) => 10.horizontalSpace,
      ),
    );
  }
}
