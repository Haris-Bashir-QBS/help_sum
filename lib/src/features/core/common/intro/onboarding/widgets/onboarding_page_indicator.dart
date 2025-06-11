import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';

class OnboardingPageIndicator extends StatelessWidget {
  final double currentPage;
  final int pageCount;

  const OnboardingPageIndicator({
    super.key,
    required this.currentPage,
    required this.pageCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(pageCount, (index) {
        double width = 8.w;
        Color color = Colors.grey;

        if (index == currentPage.floor()) {
          width = 8.w + (24.w - 8.w) * (1 - (currentPage - currentPage.floor()));
          color = AppPalette.primaryColor;
        } else if (index == currentPage.floor() + 1) {
          width = 8.w + (24.w - 8.w) * (currentPage - currentPage.floor());
          color = AppPalette.primaryColor;
        }

        return AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeInOut,
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          width: width,
          height: 8.h,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4.r),
          ),
        );
      }),
    );
  }
} 