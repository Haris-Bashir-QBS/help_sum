import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final Color? backgroundColor;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = false,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: CustomText(text: title, fontSize: 18.sp, fontWeight: FontWeight.w500, color: AppPalette.blackColor),
      actions: actions,
      leading: leading ?? IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, size: 20),
        onPressed: () => Navigator.of(context).pop(),
      ),
      centerTitle: centerTitle,
    //  backgroundColor: backgroundColor ?? AppPalette.primaryColor,
      elevation: 0,
      toolbarHeight: 60.h,
      iconTheme: const IconThemeData(color: Colors.black),
      surfaceTintColor: Colors.transparent,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(60.h);
} 