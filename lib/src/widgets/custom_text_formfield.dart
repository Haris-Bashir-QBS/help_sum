import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';

import 'custom_text.dart';

class CustomTextFormField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? initialValue;
  final bool isOutlinedBorder;
  final bool enabled;
  final BorderRadius? borderRadius;
  final Widget? rightActionWidget;
  final Function(String)? onChanged;
  final bool isPassword;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final Color? fillColor, prefixIconColor;
  final bool? readOnly;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;
  final int? maxLines;
  final TextStyle? customHintStyle;

  const CustomTextFormField({
    super.key,
    this.label,
    this.prefixIconColor,
    this.customHintStyle,
    this.hint,
    this.isPassword = false,
    this.isOutlinedBorder = true,
    this.initialValue,
    this.fillColor,
    this.focusNode,
    this.onChanged,
    this.readOnly,
    this.prefixIcon,
    this.suffixIcon,
    this.rightActionWidget,
    this.onTap,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.inputFormatters,
    this.controller,
    this.borderRadius,
    this.borderColor,
    this.enabled = true,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.maxLines = 1,
  });

  @override
  CustomTextFormFieldState createState() => CustomTextFormFieldState();
}

class CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _obscureText = true;

  InputBorder _border(Color? color) {
    final borderSide = BorderSide(
      color: color ?? AppPalette.lightGreyColor,
      width: 2,
    );

    return widget.isOutlinedBorder
        ? OutlineInputBorder(
          borderRadius: widget.borderRadius ?? BorderRadius.circular(10),
          borderSide: borderSide,
        )
        : UnderlineInputBorder(
          borderRadius: widget.borderRadius ?? BorderRadius.circular(10),
          borderSide: borderSide,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label?.isNotEmpty == true) ...[
          CustomText(
            text: widget.label ?? "",
            fontWeight: FontWeight.bold,
            fontSize: 14.sp,
            //  color: context.isDarkMode ? Colors.white : Colors.black,
          ),
          const SizedBox(height: 5),
        ],
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextFormField(
                style: TextStyle(color: Colors.black),
                enabled: (widget.enabled),
                controller: widget.controller,
                onTap: widget.onTap,
                focusNode: widget.focusNode,
                initialValue: widget.initialValue,
                obscureText: widget.isPassword ? _obscureText : false,
                keyboardType: widget.keyboardType,
                onChanged: (widget.onChanged),
                readOnly: widget.readOnly ?? false,
                decoration: buildInputDecoration(context),
                validator: widget.validator,
                inputFormatters: widget.inputFormatters,
                autofocus: false,
                maxLines: widget.maxLines,
              ),
            ),
            if (widget.rightActionWidget != null) widget.rightActionWidget!,
          ],
        ),
      ],
    );
  }

  InputDecoration buildInputDecoration(BuildContext context) {
    return InputDecoration(
      hintText: widget.hint,
      filled: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
      errorMaxLines: 3,
      fillColor: widget.fillColor ?? AppPalette.lightGreyColor,
      hintStyle:
          widget.customHintStyle ??
          TextStyle(color: AppPalette.hintColor, fontSize: 14.sp),
      prefixIcon:
          widget.prefixIcon != null
              ? Icon(
                widget.prefixIcon,
                color: widget.prefixIconColor ?? Colors.black,
              )
              : null,
      suffixIcon:
          widget.isPassword ? _passwordVisibilityIcon() : widget.suffixIcon,
      border: _border(widget.borderColor),
      enabledBorder: _border(widget.borderColor),
      focusedBorder: _border(
        widget.focusedBorderColor ?? AppPalette.darkGreyColor,
      ),
      errorBorder: _border(widget.errorBorderColor ?? Colors.red),
      focusedErrorBorder: _border(widget.errorBorderColor ?? Colors.red),
      disabledBorder: _border(widget.borderColor ?? AppPalette.lightGreyColor),
    );
  }

  Widget _passwordVisibilityIcon() {
    return IconButton(
      icon: Icon(
        _obscureText ? Icons.visibility_off : Icons.visibility,
        //  color: context.primaryColor,
        color: Colors.black,
      ),
      onPressed: () => setState(() => _obscureText = !_obscureText),
    );
  }
}
