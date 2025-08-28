import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/animation/fade_and_scale.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

class TabBarItemModel {
  final IconData icon;
  final String label;
  TabBarItemModel({required this.icon, required this.label});
}

class CustomTabbar extends StatelessWidget {
  const CustomTabbar({
    super.key,
    this.tabs = const [],
    this.onTapChanged,
    this.selectedIndex = 0,
  });
  final Function(int index)? onTapChanged;
  final int selectedIndex;
  final List<TabBarItemModel> tabs;
  @override
  @override
  Widget build(BuildContext context) {
    return FadeScaleTransitionWidget(
      duration: Duration(milliseconds: 300),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          ///Border only top and bottom
          border: Border(
            top: BorderSide(color: AppPalette.lightGreyColor, width: 1),
            bottom: BorderSide(color: AppPalette.lightGreyColor, width: 1),
          ),
          // border:
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(tabs.length, (index) {
            bool isActive = index == selectedIndex;
            return InkWell(
              onTap: () {
                if (onTapChanged != null) {
                  onTapChanged!(index);
                }
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Icon(
                        tabs[index].icon,
                        color: isActive ? AppPalette.primaryColor : Colors.grey,
                      ),

                      12.horizontalSpace,

                      CustomText(
                        text: tabs[index].label,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                  if (isActive)
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      margin: EdgeInsets.only(top: 6),
                      height: 2,
                      width: 100,
                      color: AppPalette.primaryColor,
                    ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
