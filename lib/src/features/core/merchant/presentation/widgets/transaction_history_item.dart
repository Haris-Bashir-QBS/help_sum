import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/widgets/custom_text.dart';
import 'package:shimmer/shimmer.dart';

class TransactionHistoryItemShimmer extends StatelessWidget {
  const TransactionHistoryItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppPalette.primaryColor),
        ),
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(12.r),
        // ),
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Row(
            children: [
              CircleAvatar(radius: 28.r, backgroundColor: Colors.white),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 14.h, width: 100.w, color: Colors.white),
                    SizedBox(height: 6.h),
                    Container(height: 12.h, width: 80.w, color: Colors.white),
                    SizedBox(height: 6.h),
                    Container(height: 12.h, width: 60.w, color: Colors.white),
                    SizedBox(height: 10.h),
                    Row(
                      children: List.generate(
                        5,
                        (index) => Container(
                          width: 16.w,
                          height: 16.h,
                          color: Colors.white,
                          margin: EdgeInsets.only(right: 4.w),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(height: 14.h, width: 40.w, color: Colors.white),
                  SizedBox(height: 6.h),
                  Container(height: 12.h, width: 50.w, color: Colors.white),
                  SizedBox(height: 10.h),
                  Container(
                    height: 28.h,
                    width: 60.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TransactionHistoryItem extends StatelessWidget {
  final String name;
  final String professionalTitle;
  final String jobTitle;
  final double price;
  final int stars;
  final VoidCallback? onTap;

  const TransactionHistoryItem({
    super.key,
    required this.name,
    required this.professionalTitle,
    required this.jobTitle,
    required this.price,
    this.stars = 5,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15).r,
        border: Border.all(
          color: AppPalette.primaryColor.withValues(alpha: .1),
        ),
      ),
      // elevation: 2,
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Row(
          children: [
            // Avatar Placeholder
            CircleAvatar(
              radius: 28.r,
              backgroundColor: Colors.grey.shade300,
              child: Icon(Icons.person, size: 30.sp, color: Colors.grey),
            ),
            SizedBox(width: 12.w),

            // Name, titles, stars
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    professionalTitle,
                    style: TextStyle(fontSize: 13.sp, color: Colors.grey),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    jobTitle,
                    style: TextStyle(fontSize: 13.sp, color: Colors.black87),
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: List.generate(
                      stars,
                      (index) =>
                          Icon(Icons.star, size: 16.sp, color: Colors.amber),
                    ),
                  ),
                ],
              ),
            ),

            // Right side price + button
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CustomText(
                  text: "\$${price.toStringAsFixed(0)}",
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  // style: TextStyle(
                  //   fontWeight: FontWeight.bold,
                  //   fontSize: 16.sp,
                  // ),
                ),

                CustomText(
                  text: "Order Completed",
                  fontSize: 12.sp,
                  // style: TextStyle(fontSize: 13.sp, color: Colors.grey),
                ),
                SizedBox(height: 6.h),
                Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppPalette.greyColor.withValues(alpha: .2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  // onPressed: onTap,
                  // style: ElevatedButton.styleFrom(
                  //   backgroundColor: Colors.grey.shade400,
                  //   padding: EdgeInsets.symmetric(
                  //     horizontal: 2.w,
                  //     vertical: 2.h,
                  //   ),
                  //   shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(20.r),
                  //   ),
                  // ),
                  child: CustomText(
                    text: professionalTitle,
                    fontSize: 11.sp,
                    // style: TextStyle(fontSize: 13.sp, color: Colors.black),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
