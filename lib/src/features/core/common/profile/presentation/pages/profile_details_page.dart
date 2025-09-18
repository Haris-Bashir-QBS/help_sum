import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/animation/fade_and_scale.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_role.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/dependency_injection/di_barrel.dart';
import 'package:help_sum/src/core/enums/content_type.dart';
import 'package:help_sum/src/core/router/app_routes.dart';
import 'package:help_sum/src/core/services/media_picker_service.dart';
import 'package:help_sum/src/core/themes/app_theme.dart';
import 'package:help_sum/src/core/utils/app_utils.dart';
import 'package:help_sum/src/features/auth/data/models/request/upload_file_request_model.dart';
import 'package:help_sum/src/features/auth/domain/entities/user_entity.dart';
import 'package:help_sum/src/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:help_sum/src/features/auth/presentation/bloc/portfolio/bloc/portfolio_bloc.dart';
import 'package:help_sum/src/features/auth/presentation/screens/stripe_merchant_setup_page.dart';
import 'package:help_sum/src/features/core/common/profile/presentation/bloc/bloc/profile_bloc.dart';
import 'package:help_sum/src/features/core/common/profile/presentation/widgets/custom_overlay_loader.dart';
import 'package:help_sum/src/features/core/common/profile/presentation/widgets/custom_tabbar.dart';
import 'package:help_sum/src/features/core/common/profile/presentation/widgets/info_card.dart';
import 'package:help_sum/src/features/core/common/profile/presentation/widgets/info_row.dart';
import 'package:help_sum/src/features/core/common/profile/presentation/widgets/verification_status.dart';
import 'package:help_sum/src/widgets/comman_imageview.dart';
import 'package:help_sum/src/widgets/custom_text.dart';
import 'package:help_sum/src/widgets/custom_toast.dart';
import 'package:help_sum/src/widgets/enlarged_image_view_widget.dart';
import 'package:help_sum/src/widgets/modal_progress_hud.dart';
import 'package:help_sum/src/features/core/common/profile/presentation/widgets/avatar_with_badge.dart';
import 'package:help_sum/src/features/core/merchant/presentation/widgets/rating_review_card.dart';

class ProfileDetailsPage extends StatefulWidget {
  const ProfileDetailsPage({super.key});

  @override
  State<ProfileDetailsPage> createState() => _ProfileDetailsPageState();
}

class _ProfileDetailsPageState extends State<ProfileDetailsPage> {
  late final LoginBloc _loginBloc;
  late final ProfileBloc _profileBloc;
  late final PortfolioBloc _portfolioBloc;

  final tabList = [
    TabBarItemModel(icon: Icons.person, label: "Profile"),
    TabBarItemModel(icon: Icons.photo, label: "Work"),
    TabBarItemModel(icon: Icons.favorite_border_outlined, label: "Rating"),
  ];

  @override
  void initState() {
    _loginBloc = sl<LoginBloc>();
    _profileBloc = sl<ProfileBloc>();
    _portfolioBloc = sl<PortfolioBloc>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = _loginBloc.state.userEntity;
      if (user != null && user.id != null) {
        if (user.role == AppRole.merchant.name) {
          _profileBloc.add(FetchMerchantRatings(merchantId: user.id!));
        }
        _portfolioBloc.add(UpdateUserEvent(userEntity: user));
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: _loginBloc),
          BlocProvider.value(value: _profileBloc),
          BlocProvider.value(value: _portfolioBloc),
        ],
        child: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) async {
            if (state.merchantSetupResposeEntitiy != null) {
              final checkoutUrl = state.merchantSetupResposeEntitiy?.url;

              if (checkoutUrl?.isNotEmpty == true) {
                //if (mounted) {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            StripeMerchantSetupScreen(setupUrl: checkoutUrl!),
                  ),
                );

                if (result != null && result == true) {
                  final updatedUser = state.userEntity?.copyWith(
                    isMerchant: true,
                  );

                  if (updatedUser != null) {
                    _loginBloc.add(UpdateUser(userEntity: updatedUser));
                  }
                }
                //}
              }
            }
            if (state.merchantSetupResposeEntitiy != null &&
                state.merchantSetupResposeEntitiy?.url == null &&
                state.merchantSetupResposeEntitiy?.message != null) {
              CustomToast.successToast(
                context: context,
                message: state.merchantSetupResposeEntitiy?.message ?? "",
              );
            }

            if (state.apiErrorMessage.isNotEmpty) {
              if (context.mounted) {
                CustomToast.errorToast(
                  context: context,
                  message: state.apiErrorMessage,
                );
              }
            }
          },
          builder: (event, state) {
            final user = state.userEntity;
            if (user == null) {
              return Center(child: CustomText(text: 'No user data available'));
            }

            return ModalProgressHUD(
              inAsyncCall: state.isLoading,
              child:
                  user.role == AppRole.consumer.name
                      ? SingleChildScrollView(
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          children: [
                            _buildMerchantProfileHeader(context, user),
                            SizedBox(height: 24.h),

                            CustomText(
                              text: "${user.firstName} ${user.lastName}",
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
                            ),
                            20.verticalSpace,
                            CustomText(
                              text: user.description ?? "No description added",
                            ),
                            50.verticalSpace,

                            // ElevatedButton.icon(
                            //   icon: const Icon(Icons.edit, size: 18),
                            //   onPressed: () {
                            //     context.pushNamed(
                            //       AppRoutes.editBasicInfo,
                            //       extra: user,
                            //     );
                            //   },
                            //   label: CustomText(
                            //     text: AppTexts.edit,
                            //     color: context.theme.colorScheme.onPrimary,
                            //     fontSize: 18.sp,
                            //     fontWeight: FontWeight.w500,
                            //   ),
                            // ),
                            // 20.verticalSpace,
                            _buildBasicInfoCard(context, user),
                            // 20.verticalSpace,
                            _buildSettingsExpansionTile(context),
                            // _buildContactInfoCard(context, user),
                          ],
                        ),
                      )
                      : Column(
                        children: [
                          _buildMerchantProfileHeader(context, user),
                          SizedBox(height: 16.h),
                          Expanded(child: _buildMerchantDetails(context, user)),
                        ],
                      ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBasicInfoCard(BuildContext context, UserEntity user) {
    return Column(
      children: [
        _buildMerchantInfoTile(
          context,
          icon: Icons.person,
          title: 'Update Profile',
          subtitle: 'Update name,email,phone',
          onTap: () => context.pushNamed(AppRoutes.editBasicInfo, extra: user),
        ),
        8.verticalSpace,

        _buildMerchantInfoTile(
          context,
          icon: Icons.description,
          title: 'Update Description',
          subtitle: 'Update profile description',
          onTap:
              () =>
                  context.pushNamed(AppRoutes.changeDescriptipon, extra: user),
        ),
        8.verticalSpace,
        _buildMerchantInfoTile(
          context,
          icon: Icons.credit_card_outlined,
          title: 'Manage Payment Methods',
          subtitle: 'Add or update your payment cards',
          onTap: () {
            context.pushNamed(AppRoutes.addCard);
          },
        ),

        // _buildMerchantInfoTile(
        //   context,
        //   icon: Icons.list,
        //   title: 'Contact Information',
        //   subtitle: 'Update phone,email',
        //   onTap:
        //       () => context.pushNamed(AppRoutes.editContactInfo, extra: user),
        // ),
      ],
    );
    // return InfoCard(
    //   title: AppTexts.basicInformation,
    //   children: [
    //     InfoRow(label: AppTexts.firstName, value: user.firstName ?? ""),
    //     InfoRow(label: AppTexts.lastName, value: user.lastName ?? ""),
    //   ],
    //   onPressed: () {
    //     // context.pushNamed(AppRoutes.editBasicInfo, extra: user);
    //   },
    // );
  }

  // Widget _buildContactInfoCard(BuildContext context, UserEntity user) {
  //   return InfoCard(
  //     title: AppTexts.contactInformation,
  //     children: [
  //       VerificationStatusIndicator(isVerified: user.isVerified == true),
  //       InfoRow(
  //         label: AppTexts.emailAddress,
  //         value: user.email ?? "",
  //         visible: (user.email ?? "").isNotEmpty,
  //       ),
  //       InfoRow(label: AppTexts.phoneNumber, value: user.phone ?? ""),
  //     ],
  //     onPressed: () {
  //       // context.pushNamed(AppRoutes.editBasicInfo, extra: user);
  //     },
  //   );
  // }

  Widget _buildMerchantProfileHeader(BuildContext context, UserEntity user) {
    return InkWell(
      onTap: () => context.pushNamed(AppRoutes.editBasicInfo, extra: user),
      child: SizedBox(
        height: 0.27.sh,
        child: Stack(
          clipBehavior: Clip.none,
          // fit: StackFit.passthrough,
          children: [
            Container(
              height: .20.sh,
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 120, 128, 145),
                    Color(0xFFEFF0F2),
                    Color.fromARGB(255, 132, 139, 152),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                // borderRadius: BorderRadius.only(
                //   topLeft: Radius.circular(30.r),
                //   topRight: Radius.circular(30.r),
                // ),
              ),
            ),

            Positioned(
              left: 0,
              right: 0,
              top: 0.12.sh,
              child: Center(
                child: FadeScaleTransitionWidget(
                  duration: const Duration(milliseconds: 800),
                  child: AvatarWithBadge(
                    imageUrl: user.image,
                    loginBloc: _loginBloc,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMerchantDetails(BuildContext context, UserEntity user) {
    return Column(
      children: [
        CustomText(
          text: "${user.firstName} ${user.lastName}",
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
        ),
        20.verticalSpace,
        CustomText(
          text: user.description ?? "No description added",
          color: AppPalette.greyColor,
        ),
        16.verticalSpace,
        BlocBuilder<ProfileBloc, ProfileBlocState>(
          builder: (context, state) {
            return CustomTabbar(
              tabs: tabList,
              selectedIndex: state.selectedIndex,
              onTapChanged: (index) {
                _profileBloc.add(ProfileTabChanged(selectedIndex: index));
              },
            );
          },
        ),
        10.verticalSpace,
        Expanded(child: _tabBarView(user)),
      ],
    );
  }

  _tabBarView(UserEntity user) {
    return BlocBuilder<ProfileBloc, ProfileBlocState>(
      builder: (context, state) {
        switch (state.selectedIndex) {
          case 0:
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  _buildMerchantInfoTile(
                    context,
                    icon: Icons.person,
                    title: 'Basic Information',
                    subtitle: 'Update name,email,phone',
                    onTap:
                        () => context.pushNamed(
                          AppRoutes.editBasicInfo,
                          extra: user,
                        ),
                  ),
                  8.verticalSpace,
                  _buildMerchantInfoTile(
                    context,
                    icon: Icons.monetization_on_outlined,
                    title: 'Rates Per hour',
                    subtitle: '\$${user.hourlyRate}/hr',
                    onTap: () => context.pushNamed(AppRoutes.rates),
                  ),
                  8.verticalSpace,
                  _buildMerchantInfoTile(
                    context,
                    icon: Icons.diamond_outlined,
                    title: 'Skill',
                    subtitle:
                        (user.services != null &&
                                user.services!.any(
                                  (e) =>
                                      e['name'] != null &&
                                      (e['name'] as String).trim().isNotEmpty,
                                ))
                            ? user.services!
                                .where(
                                  (e) =>
                                      e['name'] != null &&
                                      (e['name'] as String).trim().isNotEmpty,
                                )
                                .map((e) => e['name'] as String)
                                .join(', ')
                            : 'No Services Added',
                    onTap:
                        () => context.pushNamed(
                          AppRoutes.selectSkill,
                          extra: true,
                        ),
                  ),
                  8.verticalSpace,

                  _buildMerchantInfoTile(
                    context,
                    icon: Icons.schedule,
                    title: 'Schedule',
                    subtitle: AppUtils.getTodayScheduleSubtitle(user),
                    onTap:
                        () => context.pushNamed(
                          AppRoutes.createSchedule,
                          extra: true,
                        ),
                  ),
                  8.verticalSpace,
                  _buildMerchantInfoTile(
                    context,
                    icon: Icons.description_outlined,
                    title: 'Description',
                    subtitle: user.description ?? "No description added",
                    onTap:
                        () => context.pushNamed(AppRoutes.changeDescriptipon),
                    hasWarning: user.description?.isEmpty == true,
                  ),
                  8.verticalSpace,

                  // _buildWorkPhotosGallery(context, user),
                  if (user.isConsumer != true) ...[
                    8.verticalSpace,
                    _buildMerchantInfoTile(
                      context,
                      icon: Icons.schedule,
                      title: 'Setup Stripe Merchant Account',
                      subtitle: 'To receive payments',
                      onTap: () {
                        _loginBloc.add(FetchMerchantAccount(context: context));
                      },
                    ),
                    8.verticalSpace,
                    _buildMerchantInfoTile(
                      context,
                      icon: Icons.credit_card_outlined,
                      title: 'Manage Payment Methods',
                      subtitle: 'Add or update your payment cards',
                      onTap: () {
                        context.pushNamed(AppRoutes.addCard);
                      },
                    ),
                  ],
                  8.verticalSpace,

                  // Settings Expansion Tile
                  _buildSettingsExpansionTile(context),

                  8.verticalSpace,
                ],
              ),
            );

          case 1:
            return _buildMediaGrid(user);
          case 2:
            return _buildRatingsSection(user);
          default:
            return SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildMerchantInfoTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool hasWarning = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: AppPalette.whiteColor,
          border: Border.all(color: AppPalette.lightGreyColor),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
          child: Row(
            children: [
              _buildIconWithBadge(icon: icon, hasWarning: hasWarning),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(text: title, fontWeight: FontWeight.w600),
                    SizedBox(height: 10.h),
                    CustomText(text: subtitle, maxLines: 1, fontSize: 15.sp),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconWithBadge({
    required IconData icon,
    bool hasWarning = false,
  }) {
    return GestureDetector(
      onTap: () {
        // Handle icon tap if needed
      },
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          CircleAvatar(
            backgroundColor: AppPalette.lightGreyColor,
            child: Icon(icon, size: 28.sp, color: Colors.grey.shade700),
          ),
          if (hasWarning)
            Positioned(
              top: -4,
              right: -4,
              child: Container(
                padding: const EdgeInsets.all(1),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.error, color: Colors.orange, size: 14.r),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSettingsExpansionTile(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: AppPalette.whiteColor,
        border: Border.all(color: AppPalette.lightGreyColor),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          childrenPadding: EdgeInsets.only(bottom: 8.h),
          leading: CircleAvatar(
            backgroundColor: AppPalette.lightGreyColor,
            child: Icon(
              Icons.settings_outlined,
              size: 28.sp,
              color: Colors.grey.shade700,
            ),
          ),
          title: CustomText(
            text: 'Settings & Account',
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
          ),
          subtitle: CustomText(
            text: 'Terms, Privacy & Account Management',
            fontSize: 14.sp,
            color: Colors.grey[600],
          ),
          children: [
            _buildSettingsOption(
              context,
              icon: Icons.description_outlined,
              title: 'Terms & Conditions',
              subtitle: 'Read our terms of service',
              onTap: () {
                context.pushNamed(
                  AppRoutes.content,
                  extra: AppContentType.termsAndConditions,
                );
              },
            ),
            _buildSettingsOption(
              context,
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              subtitle: 'How we protect your data',
              onTap: () {
                context.pushNamed(
                  AppRoutes.content,
                  extra: AppContentType.privacyPolicy,
                );
              },
            ),
            _buildSettingsOption(
              context,
              icon: Icons.delete_forever_outlined,
              title: 'Delete Account',
              subtitle: 'Permanently remove your account',
              onTap: () {
                _showDeleteAccountDialog(context, _profileBloc);
              },
              isDestructive: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20.sp,
              color: isDestructive ? Colors.red : Colors.grey[600],
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: title,
                    fontWeight: FontWeight.w500,
                    fontSize: 15.sp,
                    color: isDestructive ? Colors.red : null,
                  ),
                  SizedBox(height: 4.h),
                  CustomText(
                    text: subtitle,
                    fontSize: 13.sp,
                    color: Colors.grey[600],
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16.sp, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  void _showDeleteAccountDialog(
    BuildContext context,
    final ProfileBloc profileBloc,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocProvider.value(
          value: profileBloc,
          child: BlocConsumer<ProfileBloc, ProfileBlocState>(
            listener: (context, state) {
              if (state.accountDeleted) {
                Navigator.of(context).pop(); // Close dialog
                // Clear user data and navigate to login/role selection
                _loginBloc.add(const LogoutUser());
                context.goNamed(AppRoutes.roleSelection, extra: true);
                CustomToast.successToast(
                  context: context,
                  message: 'Account deleted successfully',
                );
              }
              if (state.apiErrorMessage.isNotEmpty) {
                CustomToast.errorToast(
                  context: context,
                  message: state.apiErrorMessage,
                );
              }
            },
            builder: (context, state) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                title: CustomText(
                  text: 'Delete Account',
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                ),
                content: CustomText(
                  text:
                      'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently removed.',
                  fontSize: 14.sp,
                ),
                actions: [
                  TextButton(
                    onPressed:
                        state.isDeletingAccount
                            ? null
                            : () => Navigator.of(context).pop(),
                    child: CustomText(
                      text: 'Cancel',
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextButton(
                    onPressed:
                        state.isDeletingAccount
                            ? null
                            : () {
                              _profileBloc.add(const DeleteAccount());
                            },
                    child:
                        state.isDeletingAccount
                            ? SizedBox(
                              width: 20.w,
                              height: 20.h,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.red,
                              ),
                            )
                            : CustomText(
                              text: 'Delete',
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  _buildMediaGrid(UserEntity? user) {
    return BlocConsumer<PortfolioBloc, PortfolioState>(
      listener: (context, state) {
        if (state.apiErrorMessage != '') {
          CustomToast.errorToast(
            context: context,
            message: state.apiErrorMessage,
          );
        }

        if (state.isLoading && state.fileUploaded == false) {
          CustomOverlayLoader.show(
            context,
            message: "Please wait image upload is in progress...",
          );
        } else {
          CustomOverlayLoader.hide();
        }
      },
      builder: (context, state) {
        final mediaList = user?.media ?? [];
        final hasImages = mediaList.isNotEmpty;

        if (!hasImages) {
          // Show centered upload message when no images
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_a_photo_outlined,
                  size: 64.sp,
                  color: Colors.grey[400],
                ),
                SizedBox(height: 16.h),
                CustomText(
                  text: 'No portfolio images yet',
                  fontSize: 16.sp,
                  color: Colors.grey[600],
                ),
                SizedBox(height: 8.h),
                CustomText(
                  text: 'Tap the button below to add your work photos',
                  fontSize: 14.sp,
                  color: Colors.grey[500],
                ),
                SizedBox(height: 24.h),
                ElevatedButton.icon(
                  onPressed: () {
                    MediaPickerService().imageGalleryBottomSheet(
                      onMediaChanged: (v) {
                        if (v != null) {
                          final files = UploadFileRequest([File(v)]);
                          _portfolioBloc.add(
                            UpdatePortfolioEvent(params: files),
                          );
                        }
                      },
                      context: context,
                    );
                  },
                  icon: Icon(Icons.add_a_photo_outlined, size: 18),
                  label: CustomText(
                    text: 'Upload Portfolio',
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppPalette.primaryColor,
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 12.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        // Show grid with images and + button
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              SizedBox(height: 10.h),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: mediaList.length + 1, // +1 for the add button
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  if (index == mediaList.length) {
                    // Add button at the end
                    return GestureDetector(
                      onTap: () {
                        MediaPickerService().imageGalleryBottomSheet(
                          onMediaChanged: (v) {
                            if (v != null) {
                              final files = UploadFileRequest([File(v)]);
                              _portfolioBloc.add(
                                UpdatePortfolioEvent(params: files),
                              );
                            }
                          },
                          context: context,
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppPalette.lightGreyColor,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: AppPalette.primaryColor,
                            width: 0.4,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_a_photo_outlined,
                              size: 26.sp,
                              color: AppPalette.primaryColor,
                            ),
                            SizedBox(height: 4.h),
                            CustomText(
                              text: 'Add',
                              fontSize: 12.sp,
                              color: AppPalette.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // Image item
                  final url = mediaList[index];
                  final tag = 'job_image_hero_$index';

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          opaque: false,
                          pageBuilder: (BuildContext context, _, __) {
                            return EnlargedImageView(imageUrl: url, tag: tag);
                          },
                          transitionsBuilder: (_, animation, __, child) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4.r,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: CustomImageView(
                          imageType: ImageType.network,
                          imagePath: url,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Widget _buildSignOutButton(BuildContext context) {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(horizontal: 16.w),
  //     child: CustomButton(
  //       text: "Sign out",
  //       textColor: Colors.white,
  //       color: AppPalette.primaryColor,
  //       onPressed: () async {
  //         context.goNamed(AppRoutes.roleSelection, extra: true);
  //         _loginBloc.add(const LogoutUser());
  //       },
  //     ),
  //   );
  // }

  // Padding _buildSettingButton(BuildContext context) {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(horizontal: 16.w),
  //     child: CustomButton(
  //       text: AppTexts.settings,
  //       onPressed: () {
  //         context.pushNamed(AppRoutes.settings);
  //       },
  //       color: context.primaryColor,
  //     ),
  //   );
  // }

  Widget _buildRatingsSection(UserEntity user) {
    return BlocConsumer<ProfileBloc, ProfileBlocState>(
      listener: (context, state) {
        if (state.apiErrorMessage.isNotEmpty) {
          CustomToast.errorToast(
            context: context,
            message: state.apiErrorMessage,
          );
        }
      },
      builder: (context, state) {
        if (state.isLoading) {
          return Center(
            child: CircularProgressIndicator(color: AppPalette.primaryColor),
          );
        }

        if (state.ratings.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star_border, size: 64.sp, color: Colors.grey[400]),
                SizedBox(height: 16.h),
                CustomText(
                  text: 'No ratings yet',
                  fontSize: 16.sp,
                  color: Colors.grey[600],
                ),
                SizedBox(height: 8.h),
                CustomText(
                  text: 'Ratings and reviews will appear here',
                  fontSize: 14.sp,
                  color: Colors.grey[500],
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            final user = _loginBloc.state.userEntity;
            if (user != null && user.id != null) {
              _profileBloc.add(FetchMerchantRatings(merchantId: user.id!));
            }
          },
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                // Average rating summary
                _buildRatingSummary(state.ratings),
                SizedBox(height: 20.h),

                // Individual ratings
                ...state.ratings
                    .map(
                      (rating) => Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: RatingReviewCard(
                          reviewerName:
                              '${rating.consumerId.firstName} ${rating.consumerId.lastName}',
                          rating: rating.rating.toDouble(),
                          reviewText: rating.review,
                          date: rating.createdAt,
                          reviewerImage: rating.consumerId.image,
                          images: rating.images,
                        ),
                      ),
                    )
                    .toList(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRatingSummary(List<dynamic> ratings) {
    if (ratings.isEmpty) return SizedBox.shrink();

    final averageRating =
        ratings.map((r) => r.rating as int).reduce((a, b) => a + b) /
        ratings.length;
    final totalRatings = ratings.length;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppPalette.whiteColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppPalette.lightGreyColor),
      ),
      child: Row(
        children: [
          // Average rating display
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: averageRating.toStringAsFixed(1),
                fontSize: 32.sp,
                fontWeight: FontWeight.bold,
                color: AppPalette.primaryColor,
              ),
              CustomText(
                text: 'out of 5',
                fontSize: 14.sp,
                color: Colors.grey[600],
              ),
            ],
          ),
          SizedBox(width: 20.w),

          // Rating breakdown
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text:
                      'Based on $totalRatings review${totalRatings == 1 ? '' : 's'}',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: 8.h),
                CustomText(
                  text: 'Customer feedback',
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
