import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/constants/asset_paths.dart';
import 'package:help_sum/src/core/extensions/context_extensions.dart';
import 'package:help_sum/src/widgets/custom_button.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

class AnimatedStatusDialog extends StatefulWidget {
  final Widget? icon;
  final bool isSuccess;
  final String? title;
  final String? message;
  final String? primaryButtonText, primaryButtonIcon, secondaryButtonIcon;
  final VoidCallback? onPrimaryTap;
  final String? secondaryButtonText;
  final VoidCallback? onSecondaryTap;
  final bool sucessOnly;
  final bool isShowTimer; // ✅ New flag
  final Function()? onBack;

  const AnimatedStatusDialog({
    super.key,
    this.sucessOnly = false,
    this.isShowTimer = false,
    this.onBack,
    this.icon,
    required this.isSuccess,
    this.title,
    this.message,
    this.primaryButtonText,
    this.onPrimaryTap,
    this.secondaryButtonText,
    this.onSecondaryTap,
    this.primaryButtonIcon,
    this.secondaryButtonIcon,
  });

  /// 💥 Show function for convenience
  static Future<void> show({
    required BuildContext context,
    Widget? icon,
    required bool isSuccess,
    String? title,
    String? message,
    String? primaryButtonText,
    VoidCallback? onPrimaryTap,
    String? secondaryButtonText,
    String? primaryButtonIcon,
    String? secondaryButtonIcon,
    Function()? onBack,
    VoidCallback? onSecondaryTap,
    bool isShowTimer = false, // ✅ Passed to dialog
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => AnimatedStatusDialog(
            icon: icon,
            isSuccess: isSuccess,
            title: title,
            message: message,
            primaryButtonText: primaryButtonText,
            onPrimaryTap: onPrimaryTap,
            secondaryButtonText: secondaryButtonText,
            onSecondaryTap: onSecondaryTap,
            primaryButtonIcon: primaryButtonIcon,
            secondaryButtonIcon: secondaryButtonIcon,
            isShowTimer: isShowTimer,
            onBack: onBack,
          ),
    );
  }

  @override
  State<AnimatedStatusDialog> createState() => _AnimatedStatusDialogState();
}

class _AnimatedStatusDialogState extends State<AnimatedStatusDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  final bool loading = true;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );
    _scaleAnim = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
    _controller.forward();

    WidgetsBinding.instance.addPostFrameCallback((t) {
      if (widget.isShowTimer) {
        Future.delayed((Duration(seconds: 3)), () {
          widget.onBack?.call();
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnim,
      child: Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children:
                widget.isSuccess
                    ? [
                      widget.icon ??
                          Image.asset(
                            widget.isSuccess
                                ? AppAssets.successIcon
                                : AppAssets.payIcon,
                            width: 100.w,
                            height: 100.w,
                            color:
                                widget.isSuccess
                                    ? null
                                    : AppPalette.accentColor,
                          ),
                      20.verticalSpace,
                      if (!widget.isShowTimer) _title(),

                      if (widget.isShowTimer) ...[
                        CustomText(
                          text:
                              widget.title ??
                              (widget.isSuccess
                                  ? AppTexts.success
                                  : AppTexts.somethingWentWrong),
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: AppPalette.blackColor,
                          textAlign: TextAlign.center,
                          maxLines: 4,
                        ),

                        20.verticalSpace,
                        _description(),
                        40.verticalSpace,
                        Center(
                          child: CircularProgressIndicator(
                            color: AppPalette.primaryColor,
                            backgroundColor: AppPalette.primaryColor.withValues(
                              alpha: .3,
                            ),
                          ),
                        ),
                        20.verticalSpace,
                      ],

                      if (widget.icon != null) ...[
                        20.verticalSpace,
                        _actions(),
                      ],
                    ]
                    : [
                      // widget.icon ??
                      //     Image.asset(
                      //       widget.isSuccess
                      //           ? AppAssets.successIcon
                      //           : AppAssets.warningIcon,
                      //       width: 100.w,
                      //       height: 100.w,
                      //       color: widget.isSuccess ? null : AppPalette.yellowColor,
                      //     ),
                      SizedBox(height: 20.h),
                      _title(),
                      SizedBox(height: 8.h),
                      _description(),
                      SizedBox(height: 24.h),
                      _actions(),
                    ],
          ),
        ),
      ),
    );
  }

  Widget _actions() {
    return Row(
      mainAxisAlignment:
          widget.secondaryButtonText != null
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.center,
      children: [
        if (widget.secondaryButtonText != null)
          Expanded(
            child: CustomButton(
              onPressed: () {
                Navigator.pop(context);
                widget.onSecondaryTap?.call();
              },
              text: widget.secondaryButtonText ?? AppTexts.cancel,
              color: AppPalette.warningColor,
              textColor: Colors.white,
              iconWidget:
                  widget.secondaryButtonIcon == null
                      ? null
                      : Image.asset(
                        widget.secondaryButtonIcon!,
                        width: 17,
                        height: 17,
                        color: context.primaryColor,
                      ),
            ),
          ),
        5.horizontalSpace,
        Expanded(
          child: CustomButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onPrimaryTap?.call();
            },
            isBorder: true,
            //  color: context.primaryColor,
            textColor: AppPalette.warningColor,
            borderColor: AppPalette.warningColor,
            color: Colors.white,

            iconWidget:
                widget.primaryButtonIcon == null
                    ? null
                    : Image.asset(
                      widget.primaryButtonIcon!,
                      width: 17,
                      height: 17,
                      color: Colors.white,
                    ),
            text: widget.primaryButtonText ?? AppTexts.continuee,
          ),
        ),
      ],
    );
  }

  CustomText _description() {
    return CustomText(
      text:
          widget.message ??
          (widget.isSuccess
              ? AppTexts.actionCompletedSuccessfully
              : AppTexts.tryAgainLater),
      fontSize: 15.sp,
      color: AppPalette.greyColor,
      textAlign: TextAlign.center,
      maxLines: 10,
    );
  }

  CustomText _title() {
    return CustomText(
      text:
          widget.title ??
          (widget.isSuccess ? AppTexts.success : AppTexts.somethingWentWrong),
      fontSize: 17.sp,
      fontWeight: FontWeight.bold,
      color: AppPalette.darkGreyColor,
      textAlign: TextAlign.center,
      maxLines: 4,
    );
  }
}
