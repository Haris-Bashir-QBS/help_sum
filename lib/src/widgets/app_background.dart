import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/asset_paths.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

class AppBackground extends StatelessWidget {
  const AppBackground({
    super.key,
    this.onTap,
    this.title = '',
    required this.body,
  });
  final String title;
  final Widget body;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(onTap: onTap, child: Image.asset(AppAssets.cross)),
        backgroundColor: Color(0xFFF9F9F9),
        titleSpacing: 1,
        title: CustomText(
          text: title,
          fontSize: 24.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: body,
    );
  }
}
