import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final String? icon;
  final VoidCallback onTap;
  const CategoryCard({
    super.key,
    required this.title,
    this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.white,
        elevation: 8.0,
        margin: EdgeInsets.zero,
        shadowColor: Colors.black.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null && icon!.isNotEmpty)
              Image.asset(icon!, width: 40, height: 40)
            else
              Icon(Icons.photo, size: 40.sp, color: Colors.grey[600]),
            SizedBox(height: 5.0.h),
            CustomText(
              text: title,
              textAlign: TextAlign.center,
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }
}
