import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/router/app_routes.dart';
import 'package:help_sum/src/features/core/common/profile/models/user_model.dart';
import 'package:help_sum/src/features/core/common/profile/widgets/info_card.dart';
import 'package:help_sum/src/features/core/common/profile/widgets/info_row.dart';
import 'package:help_sum/src/features/core/common/profile/widgets/profile_header.dart';
import 'package:help_sum/src/features/core/common/profile/widgets/verification_status.dart';
import 'package:help_sum/src/widgets/custom_button.dart';

class ProfileDetailsPage extends StatelessWidget {
  final UserModel user;

  const ProfileDetailsPage({
    super.key,
    this.user = const UserModel(
      firstName: 'John',
      lastName: 'Doe',
      emailAddress: 'johnDoe0008@gmail.com',
      phoneNumber: '0321-0000000',
      isVerified: false,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  _buildProfileHeader(),
                  SizedBox(height: 24.h),
                  _buildBasicInfoCard(context),
                  26.verticalSpace,
                  _buildContactInfoCard(context),
                ],
              ),
            ),
          ),
          _buildSignOutButton(context),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return ProfileHeader(user: user);
  }

  Widget _buildBasicInfoCard(BuildContext context) {
    return InfoCard(
      title: AppTexts.basicInformation,
      children: [
        InfoRow(label: AppTexts.firstName, value: user.firstName),
        InfoRow(label: AppTexts.lastName, value: user.lastName),
      ],
      onPressed: () {
        context.pushNamed(AppRoutes.editBasicInfo, extra: user.copyWith());
      },
    );
  }

  Widget _buildContactInfoCard(BuildContext context) {
    return InfoCard(
      title: AppTexts.contactInformation,
      children: [
        InfoRow(
          label: AppTexts.emailAddress,
          value: user.emailAddress,
          labelWidget: VerificationStatusIndicator(isVerified: user.isVerified),
        ),
        InfoRow(label: AppTexts.phoneNumber, value: user.phoneNumber),
      ],
      onPressed: () {
        context.pushNamed(AppRoutes.editContactInfo, extra: user.copyWith());
      },
    );
  }

  Widget _buildSignOutButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: CustomButton(
        text: AppTexts.signOut,
        textColor: Colors.white,
        color: AppPalette.primaryColor,
        onPressed: () {
          context.pushNamed(AppRoutes.paymentResult, extra: true);
          debugPrint('Signing out...');
        },
      ),
    );
  }
}
