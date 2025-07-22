import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/extensions/context_extensions.dart';
import 'package:help_sum/src/core/router/app_routes.dart';
import 'package:help_sum/src/widgets/custom_app_bar.dart';
import 'package:help_sum/src/widgets/custom_button.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: AppTexts.settings),
      body: SingleChildScrollView(
        child: Column(
          spacing: 10.h,
          children: [
            10.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: CustomButton(
                text: AppTexts.managePaymentMethods,
                onPressed: () {
                  context.pushNamed(AppRoutes.addCard);
                },
                color: context.primaryColor,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: CustomButton(
                text: AppTexts.termsAndConditions,
                onPressed: () {},
                color: context.primaryColor,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: CustomButton(
                text: AppTexts.privacyPolicy,
                onPressed: () {},
                color: context.primaryColor,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: CustomButton(
                text: AppTexts.deleteAccount,
                onPressed: () {},
                color: AppPalette.redColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
