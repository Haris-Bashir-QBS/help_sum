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
        height: 40.h,
        child: Row(
          children: [
            Expanded(
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      onTapChanged(index);
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      padding: EdgeInsets.symmetric(
                        horizontal: index == 0 ? 30.w : 14.w,
                      ),
                      // width: ,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.appBorderRadius.r,
                        ),
                        color:
                            selectedIndex == index
                                ? AppPalette.orangeColor
                                : null,
                      ),
                      child: Center(
                        child: CustomText(
                          textAlign: TextAlign.start,
                          text: tabs[index],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (ctx, index) => SizedBox(width: 20.w),
                itemCount: tabs.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
