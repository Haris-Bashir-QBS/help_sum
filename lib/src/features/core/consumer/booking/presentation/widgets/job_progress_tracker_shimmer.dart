import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class JobProgressTimelineShimmer extends StatelessWidget {
  const JobProgressTimelineShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main heading shimmer
        Padding(
          padding: EdgeInsets.only(bottom: 20.h),
          child: _buildShimmerBox(width: 180.w, height: 34.h),
        ),

        // Timeline shimmer
        Column(
          children: List.generate(5, (index) {
            final bool isFirst = index == 0;
            final bool isLast = index == 4;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Timeline dots + lines
                Column(
                  children: [
                    if (!isFirst)
                      CustomPaint(
                        painter: _LinePainter(color: Colors.grey[300]!),
                        size: Size(2.w, 16.h),
                      ),
                    Container(
                      width: 14.w,
                      height: 14.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[300],
                      ),
                    ),
                    if (!isLast)
                      CustomPaint(
                        painter: _LinePainter(color: Colors.grey[300]!),
                        size: Size(2.w, 60.h),
                      ),
                  ],
                ),
                SizedBox(width: 16.w),

                // Card placeholder
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 12.h),
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildShimmerBox(width: 140.w, height: 16.h), // title
                        SizedBox(height: 8.h),
                        _buildShimmerBox(
                          width: 200.w,
                          height: 14.h,
                        ), // subtitle
                        SizedBox(height: 8.h),
                        _buildShimmerBox(width: 100.w, height: 12.h), // status
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }

  Widget _buildShimmerBox({required double width, required double height}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(6.r),
        ),
      ),
    );
  }
}

class _LinePainter extends CustomPainter {
  final Color color;

  _LinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = 2;
    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
