import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoDataFound extends StatelessWidget {
  final String message;
  final IconData icon;
  final double iconSize;

  const NoDataFound({
    Key? key,
    this.message = "No Data Found",
    this.icon = Icons.search_off_rounded,
    this.iconSize = 60,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: iconSize.r, color: Colors.grey[400]),
            SizedBox(height: 10.h),
            Text(
              message,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
