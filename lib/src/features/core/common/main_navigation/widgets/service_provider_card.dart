import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_dimensions.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/asset_paths.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

class ServiceProviderCard extends StatelessWidget {
  final String title;
  final String reviews;
  final bool? showMapIcon;
  final VoidCallback onTap;
  final VoidCallback onTapChat;
  final VoidCallback onTapMap;

  const ServiceProviderCard({
    super.key,
    required this.title,
    required this.reviews,
    required this.onTap,
    this.showMapIcon,
    required this.onTapChat,
    required this.onTapMap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingAllSides,
          ).r,
      child: Container(
        padding: EdgeInsets.all(AppDimensions.paddingAllSides.r),
        decoration: BoxDecoration(
          color: AppPalette.backgroundColor,
          border: Border(
            top: BorderSide(color: AppPalette.greyColor, width: 0.8),
            bottom: BorderSide(color: AppPalette.greyColor, width: 0.8),
          ),
          borderRadius: BorderRadius.circular(AppDimensions.appBorderRadius.r),
          boxShadow: [
            // BoxShadow(
            //   color: AppPalette.greyColor.withOpacity(0.3),
            //   spreadRadius: 2,
            //   blurRadius: 5,
            //   offset: const Offset(0, 3),
            // ),
          ],
        ),
        child: Row(
          children: [
            // Image
            CircleAvatar(
              radius: 30.r,
              backgroundImage: const NetworkImage(
                'https://picsum.photos/200',
              ), // Placeholder image
            ),
            10.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: title,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  5.verticalSpace,
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: AppPalette.starColor,
                        size: 16.sp,
                      ),
                      5.horizontalSpace,
                      CustomText(
                        text: reviews,
                        fontSize: 14.sp,
                        color: AppPalette.hintColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Chat and Map icons
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppPalette.greyColor),
                  ),
                  child: IconButton(
                    icon: Image.asset(
                      AppAssets.chatIcon,
                      color: AppPalette.blackColor,
                      width: 24.w,
                      height: 24.h,
                    ),
                    onPressed: onTapChat,
                  ),
                ),
                if (showMapIcon == true) ...[
                  10.horizontalSpace,
                  Visibility(
                    visible: showMapIcon == true,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppPalette.greyColor),
                      ),
                      child: IconButton(
                        icon: Image.asset(
                          AppAssets.trgetIcon,
                          color: AppPalette.blackColor,
                          width: 24.w,
                          height: 24.h,
                        ),
                        onPressed: onTapMap,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
