import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/asset_paths.dart';
import 'package:help_sum/src/widgets/comman_imageview.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

class WalletCard extends StatelessWidget {
  const WalletCard({super.key, required this.userName});
  final String userName;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1.sw,
      height: .32.sh,
      child: Stack(
        children: [
          CustomImageView(
            imageType: ImageType.asset,
            imagePath: AppAssets.cardBackgroundImage,
            fit: BoxFit.contain,
          ),

          Positioned(
            bottom: 70,
            left: 20,
            child: Row(
              children: [
                CustomText(
                  text: "Available Balance",
                  color: AppPalette.backgroundColor,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1,
                  fontSize: 14.sp,
                ),
                CustomText(
                  text: " \$4566",
                  color: AppPalette.backgroundColor,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 20,
            left: 20,
            child: CustomText(
              text: userName,
              color: AppPalette.backgroundColor,
              fontWeight: FontWeight.w400,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }
}
