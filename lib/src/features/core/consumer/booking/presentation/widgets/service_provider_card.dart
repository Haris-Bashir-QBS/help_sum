import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_dimensions.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

class ServiceProviderCard extends StatelessWidget {
  final String title;
  final String reviews;
  final VoidCallback onTap;

  const ServiceProviderCard({
    super.key,
    required this.title,
    required this.reviews,
    required this.onTap,
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
          borderRadius: BorderRadius.circular(AppDimensions.appBorderRadius.r),
          boxShadow: [
            BoxShadow(
              color: AppPalette.greyColor.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
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
                        color: AppPalette.orangeColor,
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
                IconButton(
                  icon: Icon(
                    Icons.chat_bubble_outline,
                    color: AppPalette.blackColor,
                  ),
                  onPressed: () {
                    // TODO: Implement chat functionality
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.location_on_outlined,
                    color: AppPalette.blackColor,
                  ),
                  onPressed: () {
                    // TODO: Implement map functionality
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
