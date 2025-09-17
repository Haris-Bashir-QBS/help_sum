import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/asset_paths.dart';
import 'package:help_sum/src/features/core/common/wallet/domain/entities/payment.dart';
import 'package:help_sum/src/widgets/comman_imageview.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

class WalletCard extends StatelessWidget {
  const WalletCard({
    super.key,
    required this.balance,
    this.payment,
    required this.userId,
    required this.name,
    this.isMerchant = false,
  });
  final double balance;
  final Payment? payment;
  final String userId;
  final String name;
  final bool isMerchant;

  @override
  Widget build(BuildContext context) {
    String safeText(String? value) {
      if (value == null || value.trim().isEmpty) return "N/A";
      return value;
    }

    String safeDouble(double? value) {
      if (value == null) return "N/A";
      return "\$${value.toStringAsFixed(2)}";
    }

    String safeDate(DateTime? date) {
      if (date == null) return "N/A";
      return date.toLocal().toString().split(' ')[0]; // YYYY-MM-DD
    }

    return SizedBox(
      width: 1.sw,
      height: 220,
      child: Stack(
        children: [
          /// Background
          Positioned.fill(
            child: CustomImageView(
              imageType: ImageType.asset,
              imagePath: AppAssets.cardBackgroundImage,
              fit: BoxFit.contain,
            ),
          ),

          Positioned(
            top: 40,
            left: 30.w,
            child: CustomText(
              text:
                  "***** **** **** ${userId.substring(userId.length - 4, userId.length)}",
              color: AppPalette.backgroundColor,
              fontWeight: FontWeight.w400,
              letterSpacing: 2,
              fontSize: 14.sp,
            ),
          ),

          Positioned(
            bottom: 20,
            left: 30.w,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: name,
                  color: AppPalette.backgroundColor,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 2,
                  fontSize: 14.sp,
                ),

                8.verticalSpace,
                CustomText(
                  text: "Available Balance",
                  color: AppPalette.backgroundColor,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1,
                  fontSize: 14.sp,
                ),
                SizedBox(height: 5.h),
                CustomText(
                  text: "\$${balance.toStringAsFixed(2)}",
                  color: AppPalette.backgroundColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.sp,
                  letterSpacing: 2,
                ),
              ],
            ),
          ),

          /// Payment details (only if available)
          // if (payment != null)
          Positioned(
            top: 40,
            right: 30,
            left: 110,
            // left: 0,
            // right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CustomText(
                  text: "Last Job: ${safeText(payment?.withUser.firstName)}",
                  color: AppPalette.backgroundColor,
                  fontSize: 12.sp,
                ),
                CustomText(
                  text: "Amount: ${safeDouble(payment?.amount)}",
                  color: AppPalette.backgroundColor,
                  fontSize: 12.sp,
                ),

                if (isMerchant)
                  CustomText(
                    text:
                        "With: ${safeText("${payment?.withUser.firstName} ${payment?.withUser.lastName}")}",
                    color: AppPalette.backgroundColor,
                    fontSize: 12.sp,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
