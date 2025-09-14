import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';

class InboxShimmer extends StatelessWidget {
  const InboxShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        padding: EdgeInsets.all(16.w),
        itemBuilder: (context, index) => _buildShimmerItem(),
        separatorBuilder: (_, __) => SizedBox(height: 12.h),
        itemCount: 8,
      ),
    );
  }

  Widget _buildShimmerItem() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppPalette.whiteColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppPalette.lightGreyColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar shimmer
          _shimmerBox(width: 50.w, height: 50.w, shape: BoxShape.circle),
          SizedBox(width: 12.w),

          // Name + Last message
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _shimmerBox(width: 140.w, height: 16.h, radius: 6.r),
                SizedBox(height: 8.h),
                _shimmerBox(width: double.infinity, height: 14.h, radius: 6.r),
              ],
            ),
          ),

          SizedBox(width: 12.w),

          // Time + unread
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _shimmerBox(width: 50.w, height: 12.h, radius: 6.r),
              SizedBox(height: 10.h),
              _shimmerBox(width: 18.w, height: 18.w, shape: BoxShape.circle),
            ],
          ),
        ],
      ),
    );
  }

  /// Helper shimmer builder
  Widget _shimmerBox({
    required double width,
    required double height,
    double? radius,
    BoxShape shape = BoxShape.rectangle,
  }) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: shape,
          borderRadius:
              shape == BoxShape.rectangle
                  ? BorderRadius.circular(radius ?? 6.r)
                  : null,
        ),
      ),
    );
  }
}
