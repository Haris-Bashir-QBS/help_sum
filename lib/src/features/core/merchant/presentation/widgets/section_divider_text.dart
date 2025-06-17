import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../widgets/custom_text.dart';

class SectionDividerText extends StatelessWidget {
  final String heading, text;
  const SectionDividerText({
    super.key,
    required this.heading,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(),
          CustomText(
            text: heading,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
          Divider(),
          CustomText(text: text, fontSize: 18.sp),
        ],
      ),
    );
  }
}
