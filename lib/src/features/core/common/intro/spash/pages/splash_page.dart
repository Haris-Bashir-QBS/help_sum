import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/router/app_routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _textColorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 20.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _textColorAnimation = ColorTween(
      begin: Colors.black,
      end: Colors.white,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.1, 0.3, curve: Curves.easeOut),
    ));

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        context.goNamed(AppRoutes.onboarding);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Stack(
      fit: StackFit.expand,
      children: [
        _buildAnimatingCircle(),
        _buildAnimatingText(),
      ],
    );
  }

  Widget _buildAnimatingCircle() {
    return Center(
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: 100.w,
              height: 100.w,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppPalette.primaryColor,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnimatingText() {
    return Center(
      child: AnimatedBuilder(
        animation: _textColorAnimation,
        builder: (context, child) {
          return Text(
            AppTexts.appTitle,
            style: TextStyle(
              color: _textColorAnimation.value,
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
          );
        },
      ),
    );
  }
}

 