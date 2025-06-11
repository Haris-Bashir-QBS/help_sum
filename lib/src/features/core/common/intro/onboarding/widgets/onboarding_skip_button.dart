import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/router/app_routes.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

class OnboardingSkipButton extends StatelessWidget {
  const OnboardingSkipButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.goNamed(AppRoutes.login);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CustomText(text: AppTexts.skip, color: Colors.white),
          10.horizontalSpace,
          Icon(
            Icons.arrow_forward_ios,
            size: 16.sp,
            color: AppPalette.orangeColor,
          ),
        ],
      ),
    );
  }
} 