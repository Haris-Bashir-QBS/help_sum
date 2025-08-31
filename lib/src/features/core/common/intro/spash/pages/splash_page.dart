import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_role.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/dependency_injection/di_barrel.dart';
import 'package:help_sum/src/core/router/app_routes.dart';
import 'package:help_sum/src/core/services/local_storage_service.dart';
import 'package:help_sum/src/features/auth/presentation/bloc/login/login_bloc.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  int _animationStep = 0;

  late final LoginBloc _loginBloc;

  // Animations
  late AnimationController _rotationController;
  late AnimationController _sizeController;
  late AnimationController _positionController;
  late AnimationController _textController;
  late AnimationController _finalExpandController;

  late Animation<double> _rotationAnimation;
  late Animation<double> _sizeAnimation;
  late Animation<Offset> _positionAnimation;
  late Animation<double> _textOpacityAnimation;
  late Animation<double> _finalExpandAnimation;
  late Animation<double> _sizeDuringRotation;

  var animationDuration = 700;

  @override
  void initState() {
    super.initState();
    _loginBloc = sl<LoginBloc>();

    // Rotation
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(begin: 0, end: 45).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.easeInOut),
    );
    final sizeTween = Tween<double>(begin: 80, end: 120);
    _sizeDuringRotation = sizeTween.animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.easeInOut),
    );

    // Shrink
    _sizeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _sizeAnimation = Tween<double>(begin: 1.0, end: 0.2).animate(
      CurvedAnimation(parent: _sizeController, curve: Curves.easeInOut),
    );

    // Position
    _positionController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _positionAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(100, 0),
    ).animate(
      CurvedAnimation(parent: _positionController, curve: Curves.easeInOut),
    );

    // Text
    _textController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _textOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeInOut),
    );

    // Final expand
    _finalExpandController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _finalExpandAnimation = Tween<double>(begin: 1.0, end: 70.0).animate(
      CurvedAnimation(parent: _finalExpandController, curve: Curves.easeInOut),
    );

    // Trigger login check after animation
    _finalExpandController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _loginBloc.add(CheckUserLoggedIn());
      }
    });

    // Start sequence
    _startAnimationSequence();
  }

  void _startAnimationSequence() {
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() => _animationStep = 1);

      Future.delayed(Duration(milliseconds: animationDuration), () {
        setState(() => _animationStep = 2);
        _rotationController.forward();

        Future.delayed(Duration(milliseconds: animationDuration), () {
          setState(() => _animationStep = 3);

          Future.delayed(Duration(milliseconds: animationDuration), () {
            setState(() => _animationStep = 4);
            _sizeController.forward();

            Future.delayed(Duration(milliseconds: animationDuration), () {
              setState(() => _animationStep = 5);
              _positionController.forward();
              _textController.forward();

              Future.delayed(Duration(milliseconds: animationDuration), () {
                _finalExpandController.forward();
              });
            });
          });
        });
      });
    });
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _sizeController.dispose();
    _positionController.dispose();
    _textController.dispose();
    _finalExpandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Reverted: background is white
      body: BlocProvider.value(
        value: _loginBloc,
        child: BlocListener<LoginBloc, LoginState>(
          listener: _listener,
          child: Center(child: _buildAnimationStep()),
        ),
      ),
    );
  }

  void _listener(ctx, state) async {
    if (state.userEntity != null) {
      final user = state.userEntity!;
      if (user.isVerified == false) {
        await LocalStorageService().clearAll();
        if (!context.mounted) {
          return;
        }
        context.goNamed(AppRoutes.roleSelection);
      } else {
        if (user.role != AppRole.consumer.name) {
          if (user.services?.isEmpty == true) {
            context.goNamed(AppRoutes.selectSkill);
          } else if (user.schedule?.isEmpty == true) {
            context.goNamed(AppRoutes.createSchedule);
          } else {
            context.goNamed(AppRoutes.mainNavigation);
          }
        } else {
          context.goNamed(AppRoutes.mainNavigation);
        }
      }
    } else {
      context.goNamed(AppRoutes.roleSelection);
    }
  }

  Widget _buildAnimationStep() {
    switch (_animationStep) {
      case 0:
        return const SizedBox.shrink();
      case 1:
        return TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 300, end: 0),
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOutBack,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, value),
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppPalette.primaryColor,
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            );
          },
        );
      case 2:
        return AnimatedBuilder(
          animation: _rotationController,
          builder: (context, child) {
            final size = _sizeDuringRotation.value;
            return Transform.rotate(
              angle: _rotationAnimation.value * 3.14159 / 180,
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: AppPalette.primaryColor, // Reverted
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            );
          },
        );
      case 3:
        return AnimatedBuilder(
          animation: _rotationController,
          builder: (context, child) {
            final size = _sizeDuringRotation.value;
            return Transform.rotate(
              angle: 45 * 3.14159 / 180,
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: AppPalette.primaryColor, // Reverted
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            );
          },
        );
      case 4:
        return AnimatedBuilder(
          animation: _sizeController,
          builder: (context, child) {
            return Transform.scale(
              scale: _sizeAnimation.value,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppPalette.primaryColor, // Reverted
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
            );
          },
        );
      case 5:
        return Stack(
          alignment: Alignment.center,
          children: [
            AnimatedBuilder(
              animation: _textController,
              builder: (context, child) {
                return Opacity(
                  opacity: _textOpacityAnimation.value,
                  child: Transform.translate(
                    offset: Offset(-50 * (1 - _textOpacityAnimation.value), 0),
                    child: Text(
                      AppTexts.appTitle,
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                        color: AppPalette.primaryColor, // Reverted
                      ),
                    ),
                  ),
                );
              },
            ),
            AnimatedBuilder(
              animation: _positionController,
              builder: (context, child) {
                return AnimatedBuilder(
                  animation: _finalExpandController,
                  builder: (context, _) {
                    return Transform.translate(
                      offset: _positionAnimation.value,
                      child: Transform.scale(
                        scale: _finalExpandAnimation.value,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: const BoxDecoration(
                            color: AppPalette.primaryColor, // Reverted
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
