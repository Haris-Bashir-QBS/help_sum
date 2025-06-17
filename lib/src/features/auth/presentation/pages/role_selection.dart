import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_role.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/constants/asset_paths.dart';
import 'package:help_sum/src/core/router/app_routes.dart';
import 'package:help_sum/src/widgets/custom_button.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Full width image as background
            Positioned.fill(
              child: Image.asset(AppAssets.roleSelection, fit: BoxFit.contain),
            ),

            // Content over the image
            Column(
              children: [
                50.verticalSpace,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: CustomText(
                    text: AppTexts.roleSelectionHeading,
                    fontWeight: FontWeight.bold,
                    fontSize: 30.sp,
                    maxLines: 5,
                    textAlign: TextAlign.center,
                  ),
                ),
                const Spacer(),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 60.w,
                    vertical: 20.h,
                  ),
                  // decoration: BoxDecoration(
                  //   color: Colors.white.withOpacity(0.95),
                  //   borderRadius: BorderRadius.vertical(
                  //     top: Radius.circular(30.r),
                  //   ),
                  // ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomText(
                        text: AppTexts.login,
                        fontWeight: FontWeight.w500,
                        fontSize: 19.sp,
                      ),
                      10.verticalSpace,
                      CustomButton(
                        text: AppTexts.merchant,
                        textColor: Colors.white,
                        color: AppPalette.primaryColor,
                        onPressed: () {
                          appRole = AppRole.merchant;
                          context.pushNamed(AppRoutes.login);
                        },
                      ),
                      10.verticalSpace,
                      CustomButton(
                        text: AppTexts.consumer,
                        textColor: Colors.white,
                        color: AppPalette.primaryColor,
                        onPressed: () {
                          appRole = AppRole.consumer;

                          context.pushNamed(AppRoutes.login);
                        },
                      ),
                    ],
                  ),
                ),
                60.verticalSpace,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
