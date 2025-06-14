import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/widgets/circular_icon_container.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

class PaymentResultActionButton extends StatelessWidget {
  final String iconPath;
  final String text;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? textColor;
  final double? iconSize;
  final double? padding;

  const PaymentResultActionButton({
    super.key,
    required this.iconPath,
    required this.text,
    required this.onTap,
    this.backgroundColor,
    this.textColor,
    this.iconSize,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: padding ?? 27.5.h),
          decoration: BoxDecoration(
            color: backgroundColor ?? AppPalette.lightGreyColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              CircularIconContainer(imagePath: iconPath, size: iconSize ?? 25),
              10.verticalSpace,
              CustomText(text: text, color: textColor),
            ],
          ),
        ),
      ),
    );
  }
}
