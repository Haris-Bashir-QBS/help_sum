import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/router/app_routes.dart';
import 'package:help_sum/src/widgets/custom_button.dart';

class OnboardingGetStartedButton extends StatelessWidget {
  const OnboardingGetStartedButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: AppTexts.getStarted,
      onPressed: () {
        context.goNamed(AppRoutes.login);
      },
      radius: 10.r,
      color: AppPalette.primaryColor,
      textColor: Colors.white,
    );
  }
} 