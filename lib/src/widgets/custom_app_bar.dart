import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool? centerTitle;
  final bool showLeading;
  final VoidCallback? onBackButtonPressed;

  const CustomAppBar({Key? key, required this.title, 
  this.centerTitle = true,
  this.showLeading = true,
  this.onBackButtonPressed})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppPalette.backgroundColor,
      elevation: 0,
    
      leading: showLeading?  IconButton(
        icon: const Icon(Icons.arrow_back_ios_new),
        color: AppPalette.blackColor,
        onPressed: onBackButtonPressed ?? () => Navigator.pop(context),
      ):null,
      title: CustomText(
        text: title,
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
      ),
      centerTitle: centerTitle,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(50.h);
}
