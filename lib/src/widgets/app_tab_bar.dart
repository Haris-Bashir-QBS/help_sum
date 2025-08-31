import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_dimensions.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

class AppTabBar extends StatelessWidget {
  const AppTabBar({
    super.key,
    required this.onTapChanged,
    this.selectedIndex = 0,
    this.tabs = const [],
  });

  final Function(int index) onTapChanged;
  final int selectedIndex;
  final List<String> tabs;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingAllSides,
          ).r,
      child: SizedBox(
        width: 1.sw,
        height: 45.h,
        child: Row(
          children: [
            Expanded(
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final isSelected = selectedIndex == index;
                  return GestureDetector(
                    onTap: () => onTapChanged(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? AppPalette.primaryColor
                                : AppPalette.lightGreyColor.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow:
                            isSelected
                                ? [
                                  BoxShadow(
                                    color: AppPalette.primaryColor.withOpacity(
                                      0.3,
                                    ),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ]
                                : [],
                      ),
                      child: Center(
                        child: CustomText(
                          text: tabs[index],
                          fontSize: isSelected ? 15.sp : 14.sp,
                          color:
                              isSelected
                                  ? Colors.white
                                  : AppPalette.secondayColor,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (ctx, index) => SizedBox(width: 12.w),
                itemCount: tabs.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
