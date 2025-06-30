import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/constants/app_role.dart';
import 'package:help_sum/src/core/constants/print_logs.dart';
import 'package:help_sum/src/core/router/app_routes.dart';
import 'package:help_sum/src/features/auth/data/models/request/otp_request_model.dart';
import 'package:help_sum/src/features/auth/presentation/controller/notifiers/auth_notifier.dart';
import 'package:help_sum/src/features/auth/presentation/controller/notifiers/auth_state.dart';
import 'package:help_sum/src/widgets/custom_toast.dart';
import 'package:help_sum/src/widgets/modal_progress_hud.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/themes/pincode_theme.dart';
import 'package:help_sum/src/widgets/animated_slide_fade.dart';
import 'package:help_sum/src/widgets/custom_button.dart';
import 'package:help_sum/src/widgets/custom_text.dart';
import 'dart:async';

class OtpVerificationPage extends ConsumerStatefulWidget {
  final String phoneNumber;
  final String userId;
  const OtpVerificationPage({
    super.key,
    required this.userId,
    required this.phoneNumber,
  });

  @override
  ConsumerState<OtpVerificationPage> createState() =>
      _OtpVerificationPageState();
}

class _OtpVerificationPageState extends ConsumerState<OtpVerificationPage> {
  final TextEditingController _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late Timer _timer;
  int _startSeconds = 30;
  bool _isVissibleButton = false;

  @override
  void initState() {
    super.initState();

    startTimer();
    _otpController.addListener(() {
      if (_otpController.text.length == 6) {
        setState(() {
          _isVissibleButton = true;
        });
      } else {
        setState(() {
          _isVissibleButton = false;
        });
      }
    });
  }

  void startTimer() {
    _startSeconds = 30;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_startSeconds == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          _startSeconds--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _listener() {
    ref.listen<AuthState>(authNotifierProvider, (prev, next) {
      if (next is OtpSuccess) {
        context.goNamed(AppRoutes.mainNavigation);
        ref.read(authNotifierProvider.notifier).reset();
      }

      if (next is OtpError) {
        CustomToast.errorToast(context: context, message: next.message);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _listener();
    final AuthState authState = ref.watch(authNotifierProvider);
    final isLoading = authState is OtpLoading;
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              160.verticalSpace,
              AnimatedSlideFade(
                delayMilliseconds: 0,
                child: _buildVerificationTitle(),
              ),
              20.verticalSpace,
              AnimatedSlideFade(
                delayMilliseconds: 100,
                child: _buildVerificationInstruction(),
              ),
              40.verticalSpace,
              AnimatedSlideFade(
                delayMilliseconds: 200,
                child: _buildOtpFields(context),
              ),
              20.verticalSpace,
              AnimatedSlideFade(
                delayMilliseconds: 300,
                child: _buildResendCodeText(),
              ),
              80.verticalSpace,
              AnimatedSlideFade(
                delayMilliseconds: 400,
                child: _buildVerifyButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVerificationTitle() {
    return CustomText(
      text: AppTexts.verificationCode,
      fontSize: 24.sp,
      fontWeight: FontWeight.bold,
      //   color: AppPalette.darkGreyColor,
    );
  }

  Widget _buildVerificationInstruction() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: CustomText(
        text: '${AppTexts.enterVerificationCode} to ${widget.phoneNumber}',
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        // color: AppPalette.hintColor,
        textAlign: TextAlign.center,
        maxLines: 2,
      ),
    );
  }

  Widget _buildOtpFields(BuildContext context) {
    return Form(
      key: _formKey,
      child: PinCodeTextField(
        appContext: context,
        controller: _otpController,
        length: 6,
        separatorBuilder: (context, index) => 14.horizontalSpace,
        obscureText: false,
        animationType: AnimationType.fade,
        pinTheme: PinCodeTheme.buildPinTheme(),
        cursorColor: AppPalette.primaryColor,
        mainAxisAlignment: MainAxisAlignment.center,
        animationDuration: const Duration(milliseconds: 300),
        textStyle: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
          //  color: AppPalette.darkGreyColor,
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (value) {
          debugPrint(value);
        },
      ),
    );
  }

  Widget _buildResendCodeText() {
    return GestureDetector(
      onTap: _startSeconds == 0 ? startTimer : null,
      child: CustomText(
        text:
            _startSeconds == 0
                ? AppTexts.resendCode
                : '${AppTexts.resendCode} in ( $_startSeconds${AppTexts.seconds} )',
        fontSize: 16.sp,
        color:
            _startSeconds == 0
                ? AppPalette.primaryColor
                : AppPalette.orangeColor,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildVerifyButton() {
    return CustomButton(
      text: AppTexts.verify,
      color: _isVissibleButton ? AppPalette.primaryColor : null,
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          debugPrint('OTP: ${_otpController.text}');
          final userId =
              ref.read(authNotifierProvider.notifier).currentUser?.id;

          printLogs(userId);

          final params = OtpRequestModel(
            userId: widget.userId,
            otp: _otpController.text == "123456" ? 123456 : _otpController.text,
          );

          ref.read(authNotifierProvider.notifier).verifyOtp(params);

          // if (appRole == AppRole.consumer) {
          //   context.goNamed(AppRoutes.mainNavigation);
          //   print("object");
          // } else {
          //   context.goNamed(AppRoutes.selectSkill);
          // }

          // context.goNamed(AppRoutes.mainNavigation);
        }
      },
      radius: 10.r,
    );
  }
}
