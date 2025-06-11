import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/features/core/common/profile/models/user_model.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

class ProfileHeader extends StatelessWidget {
  final UserModel user;

  const ProfileHeader({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        color: AppPalette.lightGreyColor,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        children: [
          10.horizontalSpace,
          CircleAvatar(
            radius: 30.w,
            backgroundColor: AppPalette.greyColor,
            child: Icon(
              Icons.person,
              size: 30.w,
              color: AppPalette.darkGreyColor,
            ),
          ),
          SizedBox(width: 16.w),
          CustomText(
            text: '${user.firstName} ${user.lastName}',
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }
} 