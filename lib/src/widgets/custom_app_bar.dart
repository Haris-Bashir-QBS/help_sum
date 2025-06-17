import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool? centerTitle;
  final bool showLeading;
  List<Widget>? actions;
  final PreferredSizeWidget? bottomWidget;
  final VoidCallback? onBackButtonPressed;

  CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.centerTitle = true,
    this.showLeading = true,
    this.onBackButtonPressed,
    this.bottomWidget,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppPalette.backgroundColor,
      elevation: 0,

      actions: actions,

      leading:
          showLeading
              ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new),
                color: AppPalette.blackColor,
                onPressed: onBackButtonPressed ?? () => Navigator.pop(context),
              )
              : null,
      bottom: bottomWidget,
      title: CustomText(
        text: title,
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
      ),
      centerTitle: centerTitle,
    );
  }

  @override
  Size get preferredSize =>
      bottomWidget != null
          ? Size.fromHeight(bottomWidget!.preferredSize.height)
          : Size.fromHeight(50.h);
}
