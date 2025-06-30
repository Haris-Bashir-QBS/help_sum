import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/constants/print_logs.dart';
import 'package:help_sum/src/core/router/app_routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/features/auth/presentation/controller/notifiers/auth_notifier.dart';
import 'package:help_sum/src/features/auth/presentation/controller/notifiers/auth_state.dart';
import 'package:help_sum/src/widgets/custom_toast.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _textColorAnimation;

  void _listener() {
    ref.listen<AuthState>(authNotifierProvider, (prev, next) {
      log(next.toString());
      if (next is LoginSuccess) {
        printLogs(next.user.id, tag: "User Verified");
        if (next.user.isVerified == false) {
          context.goNamed(
            AppRoutes.verifyOtp,
            extra: {'userId': next.user.id, 'phone': next.user.phone},
          );
        } else {
          context.goNamed(AppRoutes.mainNavigation);
        }
      }

      if (next is AuthInitial) {
        context.goNamed(AppRoutes.roleSelection);
      }
    });
  }

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
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.1, 0.3, curve: Curves.easeOut),
      ),
    );

    _controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        final authNotifier = ref.read(authNotifierProvider.notifier);
        await authNotifier.loadUserFromStorage();
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _listener();
    return Scaffold(backgroundColor: Colors.white, body: _buildBody());
  }

  Widget _buildBody() {
    return Stack(
      fit: StackFit.expand,
      children: [_buildAnimatingCircle(), _buildAnimatingText()],
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
