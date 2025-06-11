import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/themes/pincode_theme.dart';
import 'package:help_sum/src/widgets/animated_slide_fade.dart';
import 'package:help_sum/src/widgets/custom_button.dart';
import 'package:help_sum/src/widgets/custom_text.dart';
import 'dart:async';

class OtpVerificationPage extends StatefulWidget {
  final String phoneNumber;

  const OtpVerificationPage({super.key, required this.phoneNumber});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final TextEditingController _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late Timer _timer;
  int _startSeconds = 30;

  @override
  void initState() {
    super.initState();
    startTimer();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        length: 4,
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
        text: _startSeconds == 0
            ? AppTexts.resendCode
            : '${AppTexts.resendCode} in ( $_startSeconds${AppTexts.seconds} )',
        fontSize: 16.sp,
        color: _startSeconds == 0?AppPalette.primaryColor:AppPalette.orangeColor,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildVerifyButton() {
    return CustomButton(
      text: AppTexts.verify,
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          debugPrint('OTP: ${_otpController.text}');
          // TODO: Implement OTP verification logic
        }
      },
      radius: 10.r,
    );
  }
} 