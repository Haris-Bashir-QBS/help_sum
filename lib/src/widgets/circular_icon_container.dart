import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';

class CircularIconContainer extends StatelessWidget {
  final String imagePath;
  final double size;
  final double padding;
  final Color backgroundColor;
  final Color? iconColor;

  const CircularIconContainer({
    super.key,
    required this.imagePath,
    this.size = 25,
    this.padding = 10,
    this.backgroundColor = AppPalette.greyColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(shape: BoxShape.circle, color: backgroundColor),
      child: Image.asset(
        imagePath,
        width: size.w,
        height: size.w,
        color: iconColor,
      ),
    );
  }
}
