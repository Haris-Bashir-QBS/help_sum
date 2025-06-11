import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/features/core/common/intro/onboarding/widgets/onboarding_get_started_button.dart';
import 'package:help_sum/src/features/core/common/intro/onboarding/widgets/onboarding_skip_button.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

class OnboardingSlide extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final bool isLastPage;

  const OnboardingSlide({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.isLastPage,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Full screen image
        Image.asset(
          imagePath,
          fit: BoxFit.cover,
          width: 1.sw,
          height: 1.sh,
        ),
        // Gradient overlay
        Container(
          width: 1.sw,
          height: 1.sh,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withAlpha(0),     
                Colors.black.withAlpha(26),    
                Colors.black.withAlpha(70),  
                Colors.black.withAlpha(100),   
                Colors.black.withAlpha(190), 
                Colors.black.withAlpha(230),   
              ],
              stops: const [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
            ),
          ),
        ),
        // Content
        SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text:title,
                    textAlign: TextAlign.start,
                        color: Colors.white,
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                 
                    ),
                    SizedBox(height: 16.h),
                    CustomText(
                     text: description,
                  
                        color: Colors.white.withAlpha(204),
                        fontSize: 16.sp,
                    maxLines: 10,
                     
                    ),
                    SizedBox(height: 32.h),
                    isLastPage
                        ? const OnboardingGetStartedButton()
                        : const OnboardingSkipButton(),
                    SizedBox(height: isLastPage?62.h:92.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
} 