import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class DetailedMerchantCardShimmer extends StatelessWidget {
  const DetailedMerchantCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320.w,
      height: 280.h,
      margin: EdgeInsets.only(right: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with logo and name
              Row(
                children: [
                  Container(
                    width: 50.w,
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  12.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(width: 120.w, height: 18.h, color: Colors.white),
                        4.verticalSpace,
                        Container(width: 80.w, height: 14.h, color: Colors.white),
                        6.verticalSpace,
                        Container(width: 100.w, height: 14.h, color: Colors.white),
                      ],
                    ),
                  ),
                ],
              ),
              12.verticalSpace,
              // Description
              Container(width: double.infinity, height: 13.h, color: Colors.white),
              4.verticalSpace,
              Container(width: 200.w, height: 13.h, color: Colors.white),
              12.verticalSpace,
              // Availability and distance
              Row(
                children: [
                  Container(width: 40.w, height: 13.h, color: Colors.white),
                  20.horizontalSpace,
                  Container(width: 60.w, height: 13.h, color: Colors.white),
                ],
              ),
              12.verticalSpace,
              // Services chips
              Row(
                children: [
                  Container(width: 60.w, height: 20.h, color: Colors.white),
                  6.horizontalSpace,
                  Container(width: 80.w, height: 20.h, color: Colors.white),
                  6.horizontalSpace,
                  Container(width: 70.w, height: 20.h, color: Colors.white),
                ],
              ),
              16.verticalSpace,
              // Button
              Container(
                width: double.infinity,
                height: 40.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
