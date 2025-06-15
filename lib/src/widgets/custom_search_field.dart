import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../core/constants/app_dimensions.dart';
import '../core/constants/app_palette.dart';
import '../core/constants/app_texts.dart';
import 'custom_text_formfield.dart';

class CustomSearchField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final Function(String)? onChanged;
  final double? horizontalPadding;
  final Function()? onSearch;
  final bool autofocus;
  final FocusNode? focusNode;

  const CustomSearchField({
    super.key,
    this.controller,
    this.hintText,
    this.onChanged,
    this.onSearch,
    this.autofocus = false,
    this.focusNode,
    this.horizontalPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding ?? AppDimensions.paddingAllSides,
      ).copyWith(top: 10.h),
      child: CustomTextFormField(
        controller: controller,
        hint: hintText ?? AppTexts.searchHint,
        customHintStyle: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          color: AppPalette.blackColor,
        ),
        fillColor: AppPalette.fillColor,
        onChanged: onChanged,
        focusNode: focusNode,
        suffixIcon: Container(
          width: 30.w,
          decoration: BoxDecoration(
            color: AppPalette.orangeColor,
            borderRadius: BorderRadius.circular(
              AppDimensions.appBorderRadius.r,
            ),
          ),
          child: Center(
            child: IconButton(
              icon: Icon(
                Icons.search,
                color: AppPalette.blackColor,
                size: 30,
                weight: 900,
              ),
              onPressed: onSearch,
            ),
          ),
        ),
      ),
    );
  }
}
