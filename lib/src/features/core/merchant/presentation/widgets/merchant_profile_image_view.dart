import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/widgets/image_view.dart';

class MerchantProfileImageView extends StatelessWidget {
  final String imagePath;
  final Color shadowColor;

  const MerchantProfileImageView({
    super.key,
    required this.imagePath,
    required this.shadowColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: 100.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppPalette.lightGreyColor,
        border: Border.all(color: Colors.white, width: 3.w),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            spreadRadius: 2,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipOval(
        child: ImageView(
          imagePath: imagePath,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
} 