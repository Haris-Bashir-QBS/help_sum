import 'package:flutter/material.dart';
import 'package:flutter_custom_month_picker/flutter_custom_month_picker.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';

class AppUtils {
  static String maskCardNumber(String cardNumber) {
    if (cardNumber.length < 4) return cardNumber;
    return '•••• •••• •••• ${cardNumber.substring(cardNumber.length - 4)}';
  }

  static Future<void> selectExpiryDate(
    BuildContext context, {
    required dynamic Function(int, int) onSelected,
  }) async {
    showMonthPicker(
      context,
      onSelected: onSelected,
      initialSelectedMonth: DateTime.now().month,
      initialSelectedYear: DateTime.now().year,
      firstYear: 2025,
      lastYear: 2050,
      firstEnabledMonth: DateTime.now().month,
      lastEnabledMonth: 12,
      selectButtonText: AppTexts.ok,
      cancelButtonText: AppTexts.cancel,
      highlightColor: AppPalette.primaryColor,
      textColor: Colors.black,
      contentBackgroundColor: Colors.white,
      dialogBackgroundColor: Colors.grey[100],
    );
  }
}
