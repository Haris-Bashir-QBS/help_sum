import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;

  const CategoryCard({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0.r)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40.0.w, color: Colors.black.withAlpha(150)),
          SizedBox(height: 5.0.h),
          CustomText(text: title, textAlign: TextAlign.center, 
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
} 