import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_role.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/constants/asset_paths.dart';
import 'package:help_sum/src/core/utils/app_validators.dart';
import 'package:help_sum/src/features/core/common/profile/models/user_model.dart';
import 'package:help_sum/src/features/core/common/profile/widgets/info_card.dart';
import 'package:help_sum/src/features/core/common/profile/widgets/info_row.dart';
import 'package:help_sum/src/features/core/common/profile/widgets/profile_header.dart';
import 'package:help_sum/src/widgets/custom_app_bar.dart';
import 'package:help_sum/src/widgets/custom_button.dart';

class EditBasicInfoScreen extends StatefulWidget {
  final UserModel user;

  const EditBasicInfoScreen({super.key, required this.user});

  @override
  State<EditBasicInfoScreen> createState() => _EditBasicInfoScreenState();
}

class _EditBasicInfoScreenState extends State<EditBasicInfoScreen> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  final _formKey = GlobalKey<FormState>();

  Widget _buildAvatarWithBadge() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CircleAvatar(
          radius: 28.r,
          backgroundColor: Colors.grey.shade300,
          child: Icon(
            Icons.account_circle_outlined,
            size: 32.sp,
            color: Colors.grey.shade800,
          ),
        ),
        Positioned(
          top: -2,
          right: -2,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.error, color: Colors.orange, size: 18.r),
          ),
        ),
      ],
    );
  }

  Widget _buildMerchantProfileHeader(BuildContext context) {
    return InkWell(
      onTap: () {
        // context.pushNamed(AppRoutes.editBasicInfo, extra: user.copyWith());
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
        decoration: BoxDecoration(
          color: const Color(0xffF5F5F5),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            _buildAvatarWithBadge(),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Manahil Shahid',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      ...List.generate(
                        4,
                        (i) =>
                            Icon(Icons.star, color: Colors.amber, size: 16.sp),
                      ),
                      Icon(Icons.star_half, color: Colors.amber, size: 16.sp),
                      SizedBox(width: 4.w),
                      Text(
                        '4.5',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Image.asset(AppAssets.arrow),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _firstNameController = TextEditingController(text: widget.user.firstName);
    _lastNameController = TextEditingController(text: widget.user.lastName);
    _emailController = TextEditingController(text: widget.user.emailAddress);
    _phoneController = TextEditingController(text: widget.user.phoneNumber);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Implement save logic
      Navigator.pop(context);
    }
  }

  Widget _buildProfileHeader() {
    return ProfileHeader(user: widget.user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        // title: AppTexts.editBasicInformation,
        title: AppTexts.account,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              if (appRole == AppRole.merchant) ...[
                _buildMerchantProfileHeader(context),
                30.verticalSpace,
              ],

              InfoCard(
                title:
                    appRole == AppRole.merchant
                        ? "Personal Details"
                        : AppTexts.basicInformation,
                children: [
                  InfoRow(
                    label: AppTexts.firstName,
                    value: widget.user.firstName,
                    isEditable: true,
                    controller: _firstNameController,
                    validator: AppValidators.validateFullName(),
                    onChanged: (value) {
                      _formKey.currentState?.validate();
                    },
                  ),
                  InfoRow(
                    label: AppTexts.lastName,
                    value: widget.user.lastName,
                    isEditable: true,
                    controller: _lastNameController,
                    validator: AppValidators.validateFullName(),
                    onChanged: (value) {
                      _formKey.currentState?.validate();
                    },
                  ),

                  if (appRole == AppRole.merchant) ...[
                    InfoRow(
                      label: AppTexts.emailAddress,
                      value: widget.user.emailAddress,
                      isEditable: true,
                      controller: _emailController,
                      validator: AppValidators.validateEmail(),
                      onChanged: (value) {
                        _formKey.currentState?.validate();
                      },
                    ),

                    InfoRow(
                      label: AppTexts.phoneNumber,
                      value: widget.user.phoneNumber,
                      isEditable: true,
                      controller: _phoneController,
                      validator: AppValidators.validatePhoneNumber(),
                      onChanged: (value) {
                        _formKey.currentState?.validate();
                      },
                    ),
                  ],
                ],
                onPressed: () {},
              ),
              const Spacer(),
              CustomButton(
                text: AppTexts.saveChanges,
                textColor: Colors.white,
                color: AppPalette.primaryColor,
                onPressed: _saveChanges,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
