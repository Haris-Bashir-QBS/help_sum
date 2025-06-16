import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_dimensions.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/asset_paths.dart';

class ChatInputField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const ChatInputField({
    super.key,
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppDimensions.paddingAllSides.w),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Write a message',
          prefixIcon: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Transform.scale(
              scale: 0.7,
              child: Image.asset(
                AppAssets.icGallery,
                width: 20.w,
                height: 20.w,
              ),
            ),
          ),
          suffixIcon: GestureDetector(
            onTap: onSend,
            child: Transform.scale(
              scale: 0.7,
              child: Image.asset(
                AppAssets.icPlane,
                width: 20.w,
                height: 20.w,
                // color: Colors.white,
              ),
            ),
          ),
          border: _border(),
          focusedBorder: _border(),
          filled: true,
          fillColor: AppPalette.lightGreyColor,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 12.h,
          ),
        ),
        onSubmitted: (text) => onSend(),
      ),
    );
  }

  OutlineInputBorder _border() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.appBorderRadius.r),
      borderSide: BorderSide(color: AppPalette.greyColor, width: 0.8),
    );
  }
}
