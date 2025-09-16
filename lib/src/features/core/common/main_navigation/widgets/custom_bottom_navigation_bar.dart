import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_role.dart';
import 'package:help_sum/src/core/utils/app_static_data.dart';
import 'package:hugeicons/hugeicons.dart';

class AppBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final String userRole;

  const AppBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
    required this.userRole,
  });

  @override
  Widget build(BuildContext context) {
    final destinations =
        userRole == AppRole.consumer.name
            ? AppStaticData.consumerDestinations
            : AppStaticData.merchantDestinations;

    return Container(
      //padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 8.h),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
        border: Border(
          top: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        // backgroundColor: AppPalette.lightGreyColor,
        elevation: 20,
        selectedLabelStyle: TextStyle(
          fontSize: 12.sp,
          color: AppPalette.primaryColor,
          fontWeight: FontWeight.w500,
        ),
        selectedItemColor: AppPalette.primaryColor,
        selectedIconTheme: IconThemeData(
          size: 24.sp,
          color: AppPalette.primaryColor,
        ),
        unselectedLabelStyle: TextStyle(fontSize: 10.sp),
        // showSelectedLabels: false,
        // showUnselectedLabels: false,
        items:
            destinations.map((dest) {
              return BottomNavigationBarItem(
                icon: HugeIcon(
                  icon: dest.iconPath,
                  size: 30,
                  // width: 24.w,
                  // height: 24.w,
                  color: Colors.grey.withAlpha(200), // unselected color
                ),
                activeIcon: HugeIcon(
                  icon: dest.iconPath,
                  size: 30,
                  // width: 24.w,
                  // height: 24.w,
                  color: AppPalette.primaryColor, // selected color
                ),
                label: dest.label, // hides label
              );
            }).toList(),
      ),
    );
  }
}
