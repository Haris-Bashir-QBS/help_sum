import 'package:flutter/material.dart';
import 'package:help_sum/src/core/constants/app_errors.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/utils/app_regex.dart';


class AppValidators {
  static String? Function(String?) validateEmpty(String fieldName) {
    return (value) {
      if (value == null || value.trim().isEmpty) {
        return '$fieldName${AppErrors.emptyFieldError}';
      }
      return null;
    };
  }

  static String? Function(String?) validateEmail() {
    return (value) {
      if (value == null || value.trim().isEmpty) {
        return '${AppTexts.emailAddress}${AppErrors.emptyFieldError}';
      }
      if (!AppRegex.emailRegExp.hasMatch(value)) {
        return AppErrors.invalidEmail;
      }
      return null;
    };
  }

  static String? Function(String?) validatePhoneNumber() {
    return (value) {
      if (value == null || value.trim().isEmpty) {
        return AppErrors.phoneNumberInvalid;
      }
      if (!AppRegex.phoneRegExp.hasMatch(value) || value.contains('.')) {
        return AppErrors.phoneNumberInvalid;
      }
      return null;
    };
  }

  static String? Function(String?) validateFullName() {
    return (value) {
      if (value == null || value.trim().isEmpty) {
        return '${AppTexts.fullName}${AppErrors.emptyFieldError}';
      }
      if (value.trim().length < 3) {
        return AppErrors.fullNameTooShort;
      }
      if (value.trim().length > 50) {
        return AppErrors.fullNameTooLong;
      }
      return null;
    };
  }

  static String? Function(String?) validatePassword() {
    return (value) {
      if (value == null || value.trim().isEmpty) {
        return '${AppTexts.password}${AppErrors.emptyFieldError}';
      }
      if (value.length < 8) {
        return AppErrors.passwordLengthError;
      }
      if (!AppRegex.passwordRegExp.hasMatch(value)) {
        return AppErrors.passwordInvalid;
      }
      return null;
    };
  }

  static String? Function(String?) validateConfirmPassword(TextEditingController passwordController) {
    return (value) {
      if (value == null || value.trim().isEmpty) {
        return '${AppTexts.confirmPassword}${AppErrors.emptyFieldError}';
      }
      if (value.trim() != passwordController.text.trim()) {
        return AppErrors.passwordsDoNotMatch;
      }
      return null;
    };
  }

  // Card validation methods
  static String? validateCardNumber(String? value) {
    if (value == null || value.isEmpty) {
      return AppErrors.cardNumberRequired;
    }
    if (value.replaceAll(' ', '').length != 16) {
      return AppErrors.invalidCardNumberLength;
    }
    // Optionally, add Luhn check here
    return null;
  }

  static String? validateCardHolderName(String? value) {
    if (value == null || value.isEmpty) {
      return AppErrors.cardHolderRequired;
    }
    if (value.length < 3) {
      return AppErrors.invalidCardHolderLength;
    }
    return null;
  }

  static String? validateExpiryDate(String? value) {
    if (value == null || value.isEmpty) {
      return AppErrors.expiryDateRequired;
    }
    if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(value)) {
      return AppErrors.invalidExpiryFormat;
    }
    final parts = value.split('/');
    final month = int.parse(parts[0]);
    final year = int.parse(parts[1]);
    if (month < 1 || month > 12) {
      return AppErrors.invalidMonth;
    }
    final now = DateTime.now();
    final currentYear = now.year % 100;
    if (year < currentYear || (year == currentYear && month < now.month)) {
      return AppErrors.cardExpired;
    }
    return null;
  }

  static String? validateCVV(String? value) {
    if (value == null || value.isEmpty) {
      return AppErrors.cvvRequired;
    }
    if (value.length < 3 || value.length > 4) {
      return AppErrors.invalidCVV;
    }
    return null;
  }
} 