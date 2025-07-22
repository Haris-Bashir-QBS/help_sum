import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_role.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/utils/app_validators.dart';
import 'package:help_sum/src/features/auth/data/models/request/update_profile_request_model.dart';
import 'package:help_sum/src/features/auth/domain/entities/user_entity.dart';
import 'package:help_sum/src/features/auth/presentation/controller/notifiers/auth_notifier.dart';
import 'package:help_sum/src/features/auth/presentation/controller/notifiers/auth_state.dart';
import 'package:help_sum/src/features/core/common/profile/presentation/widgets/avatar_with_badge.dart';
import 'package:help_sum/src/features/core/common/profile/presentation/widgets/info_card.dart';
import 'package:help_sum/src/features/core/common/profile/presentation/widgets/info_row.dart';
import 'package:help_sum/src/features/core/common/profile/presentation/widgets/verification_status.dart';
import 'package:help_sum/src/widgets/custom_app_bar.dart';
import 'package:help_sum/src/widgets/custom_button.dart';
import 'package:help_sum/src/widgets/custom_toast.dart';
import 'package:help_sum/src/widgets/modal_progress_hud.dart';

class EditBasicInfoScreen extends ConsumerStatefulWidget {
  final UserEntity user;

  const EditBasicInfoScreen({super.key, required this.user});

  @override
  ConsumerState<EditBasicInfoScreen> createState() =>
      _EditBasicInfoScreenState();
}

class _EditBasicInfoScreenState extends ConsumerState<EditBasicInfoScreen> {
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
            AvatarWithBadge(),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.user.firstName} ${widget.user.lastName}',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  VerificationStatusIndicator(
                    isVerified: widget.user.isVerified == true,
                    alignment: Alignment.topLeft,
                  ),
                  // Row(
                  //   children: [
                  //     ...List.generate(
                  //       4,
                  //       (i) =>
                  //           Icon(Icons.star, color: Colors.amber, size: 16.sp),
                  //     ),
                  //     Icon(Icons.star_half, color: Colors.amber, size: 16.sp),
                  //     SizedBox(width: 4.w),
                  //     Text(
                  //       '4.5',
                  //       style: TextStyle(
                  //         fontSize: 14.sp,
                  //         color: Colors.grey.shade600,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
            //   Image.asset(AppAssets.arrow),
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
    _emailController = TextEditingController(text: widget.user.email);
    _phoneController = TextEditingController(text: widget.user.phone);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (_formKey.currentState?.validate() ?? false) {
      ref
          .read(authNotifierProvider.notifier)
          .updateInfo(
            context,
            UpdateProfileRequest(
              firstName: _firstNameController.text,
              lastName: _lastNameController.text,
              email: _emailController.text,
              phone: _phoneController.text,
            ),
          );
      // Navigator.pop(context);
    }
  }

  // Widget _buildProfileHeader() {
  //   return ProfileHeader(user: widget.user);
  // }

  void _listener() {
    ref.listen<AuthState>(authNotifierProvider, (prev, next) {
      if (next is SaveBasicInfoSuccess) {
        context.pop();
      } else if (next is SaveBasicInfoError) {
        CustomToast.errorToast(context: context, message: next.failure.message);
      } else if (next is SaveBasicInfoError) {
        CustomToast.errorToast(context: context, message: next.failure.message);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _listener();
    final isLoading = ref.watch(authNotifierProvider) is SaveBasicInfoLoading;
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        appBar: CustomAppBar(title: AppTexts.account),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  //   if (appRole == AppRole.merchant) ...[
                  _buildMerchantProfileHeader(context),
                  30.verticalSpace,
                  //  ],
                  InfoCard(
                    title:
                        appRole == AppRole.merchant
                            ? AppTexts.personalDetails
                            : AppTexts.basicInformation,
                    children: [
                      InfoRow(
                        label: AppTexts.firstName,
                        value: widget.user.firstName ?? "",
                        isEditable: true,
                        controller: _firstNameController,
                        validator: AppValidators.validateFullName(),
                        onChanged: (value) {
                          _formKey.currentState?.validate();
                        },
                      ),
                      InfoRow(
                        label: AppTexts.lastName,
                        value: widget.user.lastName ?? "",
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
                          value: widget.user.email ?? "",
                          isEditable: true,
                          controller: _emailController,
                          validator: AppValidators.validateEmail(),
                          onChanged: (value) {
                            _formKey.currentState?.validate();
                          },
                        ),

                        InfoRow(
                          label: AppTexts.phoneNumber,
                          value: widget.user.phone ?? "",
                          isEditable: false,
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

                  // const Spacer(),
                  30.verticalSpace,
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
        ),
      ),
    );
  }
}
