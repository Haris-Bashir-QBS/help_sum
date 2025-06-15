import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_dimensions.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

class BookingStatusHeader extends StatelessWidget {
  final String? text;
  final bool? showContractTag;
  const BookingStatusHeader({super.key, this.text, this.showContractTag});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingAllSides,
        vertical: 20.h,
      ),
      decoration: BoxDecoration(color: AppPalette.lightGreyColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: text ?? "",
            fontSize: 23.sp,
            fontWeight: FontWeight.w500,
          ),
          Visibility(
            visible: showContractTag == true,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              decoration: BoxDecoration(
                color: AppPalette.orangeColor,
                borderRadius: BorderRadius.circular(
                  AppDimensions.appBorderRadius,
                ),
              ),
              child: CustomText(
                text: AppTexts.contract,
                color: AppPalette.blackColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
