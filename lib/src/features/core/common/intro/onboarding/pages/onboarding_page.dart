import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/utils/app_static_data.dart';
import 'package:help_sum/src/features/core/common/intro/onboarding/widgets/onboarding_page_indicator.dart';
import 'package:help_sum/src/features/core/common/intro/onboarding/widgets/onboarding_slide.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  double _currentPage = 0.0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page ?? 0.0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _buildPageView(),
          _buildPageIndicator(),
        ],
      ),
    );
  }

  Widget _buildPageView() {
    return PageView(
      controller: _pageController,
      onPageChanged: (index) {
        // No need to setState here as listener handles it
      },
      children: AppStaticData.onboardingSlides.map((slide) => OnboardingSlide(
        key: ValueKey(slide.imagePath),
        imagePath: slide.imagePath,
        title: slide.title,
        description: slide.description,
        isLastPage: slide.isLastPage,
      )).toList(),
    );
  }

  Widget _buildPageIndicator() {
    return Positioned(
      bottom: 290.h,
      left: 0,
      right: 0,
      child: OnboardingPageIndicator(
        currentPage: _currentPage,
        pageCount: AppStaticData.onboardingSlides.length,
      ),
    );
  }
} 