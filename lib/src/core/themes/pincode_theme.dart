import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';

class PinCodeTheme {
  static PinTheme buildPinTheme() {
    return PinTheme(
      shape: PinCodeFieldShape.underline,
      fieldHeight: 50.h,
      fieldWidth: 50.w,
      activeFillColor: Colors.transparent,
      inactiveFillColor: Colors.transparent,
      selectedFillColor: Colors.transparent,
      activeColor: AppPalette.darkGreyColor,
      inactiveColor: AppPalette.darkGreyColor,
      selectedColor: AppPalette.primaryColor,
    );
  }
} 