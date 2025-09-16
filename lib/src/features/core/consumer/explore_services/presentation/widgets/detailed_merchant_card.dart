import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

class DetailedMerchantCard extends StatelessWidget {
  final String name;
  final String? rating;
  final String distance;
  final String pricePerHour;
  final String imageUrl;
  final String? category;
  final String? description;
  final List<String>? services;
  final VoidCallback onTap;

  const DetailedMerchantCard({
    super.key,
    required this.name,
    this.rating,
    required this.distance,
    required this.pricePerHour,
    required this.imageUrl,
    this.category,
    this.description,
    this.services,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 320.w,
        margin: EdgeInsets.only(right: 12.w),
        padding: EdgeInsets.all(16.w),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with logo, name, category, rating, and verification
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo/Image
                Container(
                  width: 50.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: AppPalette.primaryColor.withOpacity(0.1),
                  ),
                  child:
                      imageUrl.isNotEmpty
                          ? ClipRRect(
                            borderRadius: BorderRadius.circular(8.r),
                            child: Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.business,
                                  size: 24.w,
                                  color: AppPalette.primaryColor,
                                );
                              },
                            ),
                          )
                          : Icon(
                            Icons.business,
                            size: 24.w,
                            color: AppPalette.primaryColor,
                          ),
                ),
                12.horizontalSpace,
                // Name, category, rating
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: name,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppPalette.blackColor,
                      ),
                      4.verticalSpace,
                      if (category != null)
                        CustomText(
                          text: category!,
                          fontSize: 14.sp,
                          color: AppPalette.greyColor,
                        ),
                      6.verticalSpace,
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: AppPalette.starColor,
                            size: 16.w,
                          ),
                          4.horizontalSpace,
                          CustomText(
                            text: rating ?? "N/A",
                            fontSize: 14.sp,
                            color: AppPalette.blackColor,
                          ),
                          12.horizontalSpace,
                          // Verification badge
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.verified,
                                  color: Colors.green,
                                  size: 12.w,
                                ),
                                4.horizontalSpace,
                                CustomText(
                                  text: "Verified",
                                  fontSize: 10.sp,
                                  color: Colors.green,
                                  fontWeight: FontWeight.w500,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            12.verticalSpace,

            // Description
            if (description != null)
              CustomText(
                text: description!,
                fontSize: 13.sp,
                color: AppPalette.greyColor,
                maxLines: 2,
              ),

            12.verticalSpace,

            // Availability and Distance
            Row(
              children: [
                Row(
                  children: [
                    // Icon(Icons.access_time, color: AppPalette.greyColor, size: 16.w),
                    // 6.horizontalSpace,
                    // CustomText(
                    //   text: "24/7",
                    //   fontSize: 13.sp,
                    //   color: AppPalette.greyColor,
                    // ),
                  ],
                ),
                //  20.horizontalSpace,
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: AppPalette.greyColor,
                      size: 16.w,
                    ),
                    6.horizontalSpace,
                    CustomText(
                      text: distance,
                      fontSize: 13.sp,
                      color: AppPalette.greyColor,
                    ),
                  ],
                ),
              ],
            ),

            12.verticalSpace,

            // Services chips
            if (services != null && services!.isNotEmpty)
              Wrap(
                spacing: 6.w,
                runSpacing: 6.h,
                children:
                    services!.take(3).map((service) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppPalette.extraLightGreyColor,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: CustomText(
                          text: service,
                          fontSize: 11.sp,
                          color: AppPalette.greyColor,
                        ),
                      );
                    }).toList(),
              ),

            // 16.verticalSpace,
            //
            // // View Profile Button
            // SizedBox(
            //   width: double.infinity,
            //   child: ElevatedButton(
            //     onPressed: onTap,
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: AppPalette.blackColor,
            //       foregroundColor: Colors.white,
            //       padding: EdgeInsets.symmetric(vertical: 12.h),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(8.r),
            //       ),
            //       elevation: 0,
            //     ),
            //     child: CustomText(
            //       text: "View Profile",
            //       fontSize: 14.sp,
            //       fontWeight: FontWeight.w600,
            //       color: Colors.white,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
