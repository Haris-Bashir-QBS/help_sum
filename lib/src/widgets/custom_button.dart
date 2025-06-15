import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/extensions/context_extensions.dart';
import 'custom_text.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final double? height;
  final VoidCallback onPressed;
  final bool? isBorder;
  final Color? textColor, iconColor, borderColor;
  final bool isLoading;
  final Color? color;
  final double? radius;
  final bool? isKeyboardDismissOnClick;
  final Gradient? gradient;
  final IconData? icon;
  final Widget? iconWidget;

  const CustomButton({
    super.key,
    required this.text,
    this.height,
    this.iconColor,
    required this.onPressed,
    this.isBorder = false,
    this.borderColor,
    this.radius,
    this.isLoading = false,
    this.color,
    this.gradient,
    this.isKeyboardDismissOnClick = true,
    this.icon,
    this.iconWidget,
    this.textColor,
  });

  const CustomButton.bordered({
    super.key,
    required this.text,
    required this.onPressed,
    this.height,
    this.icon,
    this.iconWidget,
    this.isLoading = false,
    this.radius,
    this.iconColor,
    this.isKeyboardDismissOnClick = true,
  }) : isBorder = true,
       borderColor = AppPalette.greyColor,
       color = Colors.white,
       textColor = null,
       gradient = null;

  @override
  Widget build(BuildContext context) {
    final effectiveTextColor =
        textColor ??
        (color == Colors.white ? Colors.black : AppPalette.darkGreyColor);
    final effectiveBorderColor =
        borderColor ?? (isBorder! ? context.primaryColor : Colors.transparent);

    return SizedBox(
      width: 1.sw,
      height: height ?? 50.h,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius ?? 8),
          border:
              isBorder!
                  ? Border.all(color: effectiveBorderColor, width: 1.5)
                  : null,
          color:
              isLoading
                  ? Colors.grey.withAlpha(100)
                  : color ?? AppPalette.greyColor,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(radius ?? 8),
            splashColor: Colors.grey.withAlpha(120),
            splashFactory: InkRipple.splashFactory,
            onTap: () {
              if (isKeyboardDismissOnClick!) {
                context.dismissKeyboard();
              }
              if (!isLoading) {
                onPressed();
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading)
                  Transform.scale(
                    scale: 0.7,
                    child: const CircularProgressIndicator(color: Colors.white),
                  )
                else ...[
                  if (icon != null || iconWidget != null) ...[
                    iconWidget ??
                        Icon(
                          icon,
                          color: iconColor ?? effectiveTextColor,
                          size: 20,
                        ),
                    5.horizontalSpace,
                  ],
                  _titleWidget(effectiveTextColor),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _titleWidget(Color effectiveTextColor) {
    print("Color is ${effectiveTextColor.hashCode}");
    return Align(
      alignment: Alignment.center,
      child:
          isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : CustomText(
                text: text,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: effectiveTextColor,
                textAlign: TextAlign.center,
              ),
    );
  }
}
