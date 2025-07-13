import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Widget? labelWidget;
  final bool isEditable;
  final TextEditingController? controller;
  final String? errorText;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
    this.labelWidget,
    this.isEditable = false,
    this.controller,
    this.errorText,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomText(
                text: '$label ',
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: AppPalette.darkGreyColor,
              ),
              if(labelWidget!=null)
                labelWidget!,
            ],
          ),
          8.verticalSpace,
          isEditable
              ? _textFormField()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: value,
                      fontSize: 14.sp,
                    ),
                    7.verticalSpace,
                    Divider(),
                  ],
                ),
          7.verticalSpace
        ],
      ),
    );
  }

  TextFormField _textFormField() {
    return TextFormField(
                controller: controller,
                onChanged: onChanged,
                validator: validator,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppPalette.blackColor,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 8.h),
                  border: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: AppPalette.greyColor,
                    ),
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: AppPalette.greyColor,
                    ),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: AppPalette.primaryColor,
                    ),
                  ),
                  errorBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: AppPalette.errorColor,
                    ),
                  ),
                  errorText: errorText,
                )
              );
  }
} 