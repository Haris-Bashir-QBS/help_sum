import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

class TotalAmountWidget extends StatelessWidget {
  final String amount;
  const TotalAmountWidget({super.key, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(text: AppTexts.totalAmount, fontWeight: FontWeight.w500),
          CustomText(text: amount, fontWeight: FontWeight.w500),
        ],
      ),
    );
  }
}
