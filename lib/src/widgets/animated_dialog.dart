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
  final String? primaryButtonText;
  final String? secondaryButtonText;
  final VoidCallback? onPrimaryTap;
  final VoidCallback? onSecondaryTap;
  final bool successOnly;
  final bool isShowTimer;
  final Function()? onBack;

  const AnimatedStatusDialog({
    super.key,
    this.successOnly = false,
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
  });

  static Future<void> show({
    required BuildContext context,
    Widget? icon,
    required bool isSuccess,
    bool successOnly = false,
    String? title,
    String? message,
    String? primaryButtonText,
    VoidCallback? onPrimaryTap,
    String? secondaryButtonText,
    VoidCallback? onSecondaryTap,
    bool isShowTimer = false,
    Function()? onBack,
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
            successOnly: successOnly,
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

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _scaleAnim = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _controller.forward();

    if (widget.isShowTimer) {
      Future.delayed(const Duration(seconds: 3), () {
        widget.onBack?.call();
        if (mounted) Navigator.pop(context);
      });
    }
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        elevation: 10,
        backgroundColor: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildIcon(),
              16.verticalSpace,
              _title(),
              8.verticalSpace,
              _description(),
              24.verticalSpace,
              if (!widget.successOnly) _actions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // gradient: LinearGradient(
        //   colors:
        //       widget.isSuccess
        //           ? [
        //             Colors.green.shade400,
        //             Colors.green.shade700,
        //           ] // Success gradient
        //           : [
        //             Colors.orange.shade300,
        //             Colors.red.shade400,
        //           ], // Warning gradient
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomRight,
        // ),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.1),
        //     blurRadius: 10,
        //     offset: const Offset(0, 5),
        //   ),
        //   ],
      ),
      child:
          widget.icon ??
          Image.asset(
            widget.isSuccess ? AppAssets.successIcon : AppAssets.successIcon,
            width: 80.w,
            height: 80.w,
          ),
    );
  }

  CustomText _title() => CustomText(
    text:
        widget.title ??
        (widget.isSuccess ? AppTexts.success : AppTexts.somethingWentWrong),
    fontSize: 18.sp,
    fontWeight: FontWeight.bold,
    color: AppPalette.darkGreyColor,
    textAlign: TextAlign.center,
  );

  CustomText _description() => CustomText(
    text:
        widget.message ??
        (widget.isSuccess
            ? AppTexts.actionCompletedSuccessfully
            : AppTexts.tryAgainLater),
    fontSize: 14.sp,
    color: AppPalette.greyColor,
    textAlign: TextAlign.center,
  );

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
              text: widget.secondaryButtonText!,
              color: AppPalette.warningColor,
              textColor: Colors.white,
              height: 45.h,
              radius: 12.r,
              // shadow: true,
            ),
          ),
        if (widget.secondaryButtonText != null) 10.horizontalSpace,
        Expanded(
          child: CustomButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onPrimaryTap?.call();
            },
            text: widget.primaryButtonText ?? AppTexts.continuee,
            color: AppPalette.primaryColor,
            textColor: Colors.white,
            height: 45.h,
            radius: 12.r,
            // shadow: true,
          ),
        ),
      ],
    );
  }
}
