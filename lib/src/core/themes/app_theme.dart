import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      // Primary Colors
      primarySwatch: AppPalette.whiteSwatch,
      primaryColor: AppPalette.primaryColor,
      colorScheme: ColorScheme.light(
        primary: AppPalette.primaryColor,
        secondary: AppPalette.secondaryColor,
        surface: AppPalette.whiteColor,
        error: AppPalette.errorColor,
        onPrimary: AppPalette.whiteColor,
        onSecondary: AppPalette.blackColor,
        onSurface: AppPalette.blackColor,
        onError: AppPalette.whiteColor,
      ),

      // App Bar Theme
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: AppPalette.whiteColor,
        foregroundColor: AppPalette.blackColor,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppPalette.blackColor,
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: AppPalette.blackColor, size: 24.sp),
      ),

      // Scaffold Theme
      scaffoldBackgroundColor: AppPalette.backgroundColor,

      // Icon Theme
      iconTheme: IconThemeData(color: AppPalette.blackColor, size: 24.sp),

      // Text Theme
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 32.sp,
          fontWeight: FontWeight.bold,
          color: AppPalette.blackColor,
        ),
        displayMedium: TextStyle(
          fontSize: 28.sp,
          fontWeight: FontWeight.bold,
          color: AppPalette.blackColor,
        ),
        displaySmall: TextStyle(
          fontSize: 24.sp,
          fontWeight: FontWeight.bold,
          color: AppPalette.blackColor,
        ),
        headlineLarge: TextStyle(
          fontSize: 22.sp,
          fontWeight: FontWeight.w600,
          color: AppPalette.blackColor,
        ),
        headlineMedium: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
          color: AppPalette.blackColor,
        ),
        headlineSmall: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: AppPalette.blackColor,
        ),
        titleLarge: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: AppPalette.blackColor,
        ),
        titleMedium: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: AppPalette.blackColor,
        ),
        titleSmall: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: AppPalette.greyColor,
        ),
        bodyLarge: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.normal,
          color: AppPalette.blackColor,
        ),
        bodyMedium: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.normal,
          color: AppPalette.blackColor,
        ),
        bodySmall: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.normal,
          color: AppPalette.greyColor,
        ),
        labelLarge: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: AppPalette.primaryColor,
        ),
        labelMedium: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: AppPalette.greyColor,
        ),
        labelSmall: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w500,
          color: AppPalette.greyColor,
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppPalette.fillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(
            color: AppPalette.greyColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(
            color: AppPalette.greyColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: AppPalette.primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: AppPalette.errorColor, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: AppPalette.errorColor, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        hintStyle: TextStyle(color: AppPalette.hintColor, fontSize: 14.sp),
        labelStyle: TextStyle(color: AppPalette.greyColor, fontSize: 14.sp),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppPalette.primaryColor,
          foregroundColor: AppPalette.whiteColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
          textStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppPalette.primaryColor,
          side: BorderSide(color: AppPalette.primaryColor, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
          textStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppPalette.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          textStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
        ),
      ),

      // Card Theme
      cardTheme: CardTheme(
        color: AppPalette.whiteColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      ),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: AppPalette.greyColor.withOpacity(0.3),
        space: 24.h,
        thickness: 1,
      ),

      // Text Selection Theme
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppPalette.primaryColor,
        selectionColor: AppPalette.primaryColor.withOpacity(0.3),
        selectionHandleColor: AppPalette.primaryColor,
      ),

      // Use Material 3
      useMaterial3: false,
    );
  }
}
