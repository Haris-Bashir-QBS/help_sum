import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final String? icon;
  final VoidCallback onTap;
  final bool glassmorphic;

  const CategoryCard({
    super.key,
    required this.title,
    this.icon,
    required this.onTap,
    this.glassmorphic = false,
  });

  /// ✅ Named constructor for glassmorphic version
  factory CategoryCard.glassmorphic({
    required String title,
    String? icon,
    required VoidCallback onTap,
  }) {
    return CategoryCard(
      title: title,
      icon: icon,
      onTap: onTap,
      glassmorphic: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: glassmorphic ? _buildGlassCard() : _buildNormalCard(),
    );
  }

  Widget _buildNormalCard() {
    return Card(
      color: Colors.white,
      elevation: 8.0,
      margin: EdgeInsets.zero,
      shadowColor: Colors.black.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.0.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null && icon!.isNotEmpty)
            Image.asset(icon!, width: 40, height: 40)
          else
            Icon(Icons.photo, size: 40.sp, color: AppPalette.primaryColor),
          SizedBox(height: 5.0.h),
          CustomText(
            text: title,
            textAlign: TextAlign.center,
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }

  Widget _buildGlassCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14.0.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Container(
          decoration: BoxDecoration(
            color: AppPalette.primaryColor.withOpacity(
              0.7,
            ), // glassy background
            borderRadius: BorderRadius.circular(14.0.r),
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null && icon!.isNotEmpty)
                Image.asset(icon!, width: 40, height: 40, color: Colors.white)
              else
                Icon(Icons.photo, size: 40.sp, color: Colors.white),
              SizedBox(height: 5.0.h),
              CustomText(
                text: title,
                textAlign: TextAlign.center,
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
