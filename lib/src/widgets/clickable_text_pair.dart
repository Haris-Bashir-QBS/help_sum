import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

class ClickableTextPair extends StatelessWidget {
  final String firstText;
  final TextStyle? firstTextStyle;
  final String secondText;
  final TextStyle? secondTextStyle;
  final VoidCallback? onSecondTextTap;

  const ClickableTextPair({super.key, 
    required this.firstText,
    this.firstTextStyle,
    required this.secondText,
    this.secondTextStyle,
    this.onSecondTextTap,
  }) ;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomText(
          text: firstText,
          fontSize: firstTextStyle?.fontSize ?? 16.sp,
          color: firstTextStyle?.color ?? Colors.black54,
          fontWeight: firstTextStyle?.fontWeight ?? FontWeight.normal,
        ),
        GestureDetector(
          onTap: onSecondTextTap,
          child: CustomText(
            text: secondText,
            fontSize: secondTextStyle?.fontSize ?? 16.sp,
            fontWeight: secondTextStyle?.fontWeight ?? FontWeight.bold,
            color: secondTextStyle?.color ?? Colors.orange,
          ),
        ),
      ],
    );
  }
} 