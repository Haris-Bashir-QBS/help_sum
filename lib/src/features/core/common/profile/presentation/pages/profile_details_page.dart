import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/animation/fade_and_scale.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_role.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/constants/asset_paths.dart';
import 'package:help_sum/src/core/dependency_injection/di_barrel.dart';
import 'package:help_sum/src/core/extensions/context_extensions.dart';
import 'package:help_sum/src/core/router/app_routes.dart';
import 'package:help_sum/src/core/themes/app_theme.dart';
import 'package:help_sum/src/core/utils/app_utils.dart';
import 'package:help_sum/src/features/auth/domain/entities/user_entity.dart';
import 'package:help_sum/src/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:help_sum/src/features/auth/presentation/screens/stripe_merchant_setup_page.dart';
import 'package:help_sum/src/features/core/common/profile/presentation/widgets/info_card.dart';
import 'package:help_sum/src/features/core/common/profile/presentation/widgets/info_row.dart';
import 'package:help_sum/src/features/core/common/profile/presentation/widgets/verification_status.dart';
import 'package:help_sum/src/features/core/consumer/booking/presentation/widgets/job_image_slider.dart';
import 'package:help_sum/src/widgets/custom_button.dart';
import 'package:help_sum/src/widgets/custom_text.dart';
import 'package:help_sum/src/widgets/custom_toast.dart';
import 'package:help_sum/src/widgets/modal_progress_hud.dart';
import 'package:help_sum/src/features/core/common/profile/presentation/widgets/avatar_with_badge.dart';

class ProfileDetailsPage extends StatefulWidget {
  const ProfileDetailsPage({super.key});

  @override
  State<ProfileDetailsPage> createState() => _ProfileDetailsPageState();
}

class _ProfileDetailsPageState extends State<ProfileDetailsPage> {
  late final LoginBloc _loginBloc;

  @override
  void initState() {
    _loginBloc = sl<LoginBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocProvider.value(
        value: _loginBloc,
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
            if (state.apiErrorMessage.isNotEmpty) {
              CustomToast.errorToast(
                context: context,
                message: state.apiErrorMessage,
              );
            }
            // if (state.apiErrorMessage.isNotEmpty) {
            //   AppUtils.showErrorSnackBar(context, state.apiErrorMessage);
            // }
          },
          builder: (event, state) {
            final user = state.userEntity;
            if (user == null) {
              return Center(child: CustomText(text: 'No user data available'));
            }

            return ModalProgressHUD(
              inAsyncCall: state.isLoading,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        children:
                            user.role == AppRole.consumer.name
                                ? [
                                  _buildMerchantProfileHeader(context, user),
                                  SizedBox(height: 24.h),
                                  CustomText(
                                    text: "${user.firstName} ${user.lastName}",
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  20.verticalSpace,
                                  CustomText(
                                    text:
                                        user.description ??
                                        "No description added",
                                  ),

                                  20.verticalSpace,
                                  ElevatedButton.icon(
                                    icon: const Icon(Icons.edit, size: 18),
                                    onPressed: () {
                                      context.pushNamed(
                                        AppRoutes.editBasicInfo,
                                        extra: user,
                                      );
                                    },
                                    label: CustomText(
                                      text: AppTexts.edit,
                                      color:
                                          context.theme.colorScheme.onPrimary,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  20.verticalSpace,

                                  _buildBasicInfoCard(context, user),
                                  26.verticalSpace,
                                  _buildContactInfoCard(context, user),
                                ]
                                : [
                                  _buildMerchantProfileHeader(context, user),
                                  SizedBox(height: 16.h),
                                  _buildMerchantDetails(context, user),
                                ],
                      ),
                    ),
                  ),

                  _buildSettingButton(context),
                  10.verticalSpace,
                  _buildSignOutButton(context),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Padding _buildSettingButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: CustomButton(
        text: AppTexts.settings,
        onPressed: () {
          context.pushNamed(AppRoutes.settings);
        },
        color: context.primaryColor,
      ),
    );
  }

  Widget _buildBasicInfoCard(BuildContext context, UserEntity user) {
    return InfoCard(
      title: AppTexts.basicInformation,
      children: [
        InfoRow(label: AppTexts.firstName, value: user.firstName ?? ""),
        InfoRow(label: AppTexts.lastName, value: user.lastName ?? ""),
      ],
      onPressed: () {
        // context.pushNamed(AppRoutes.editBasicInfo, extra: user);
      },
    );
  }

  Widget _buildContactInfoCard(BuildContext context, UserEntity user) {
    return InfoCard(
      title: AppTexts.contactInformation,
      children: [
        VerificationStatusIndicator(isVerified: user.isVerified == true),
        InfoRow(
          label: AppTexts.emailAddress,
          value: user.email ?? "",
          visible: (user.email ?? "")!.isNotEmpty,
        ),
        InfoRow(label: AppTexts.phoneNumber, value: user.phone ?? ""),
      ],
      onPressed: () {
        // context.pushNamed(AppRoutes.editBasicInfo, extra: user);
      },
    );
  }

  Widget _buildMerchantProfileHeader(
    BuildContext context,
    UserEntity user, {
    bool? showRating = true,
  }) {
    return InkWell(
      onTap: () => context.pushNamed(AppRoutes.editBasicInfo, extra: user),
      child: SizedBox(
        height: 0.27.sh,
        child: Stack(
          clipBehavior: Clip.none,
          // fit: StackFit.passthrough,
          children: [
            FadeScaleTransitionWidget(
              duration: const Duration(milliseconds: 400),
              child: Container(
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
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.r),
                    topRight: Radius.circular(30.r),
                  ),
                ),
              ),
            ),

            Positioned(
              left: 0,
              right: 0,
              top: 0.12.sh,
              child: Center(
                child: FadeScaleTransitionWidget(
                  duration: const Duration(milliseconds: 800),
                  child: AvatarWithBadge(),
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
        CustomText(text: user.description ?? "No description added"),

        40.verticalSpace,
        Container(
          decoration: BoxDecoration(
            color: context.theme.cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              _buildMerchantInfoTile(
                context,
                icon: Icons.monetization_on_outlined,
                title: 'Rates Per hour',
                subtitle: '\$${user.hourlyRate}/hr',
                onTap: () => context.pushNamed(AppRoutes.rates),
              ),
              const Divider(),
              _buildMerchantInfoTile(
                context,
                icon: Icons.diamond_outlined,
                title: 'Skill',
                subtitle:
                    user.services != null && user.services!.isNotEmpty
                        ? user.services!
                            .map((e) => e['name'])
                            .join(', ')
                            .toString()
                        : 'No Services Added',
                onTap:
                    () => context.pushNamed(AppRoutes.selectSkill, extra: true),
              ),
              const Divider(),
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
              const Divider(),
              _buildMerchantInfoTile(
                context,
                icon: Icons.description_outlined,
                title: 'Description',
                subtitle: user.description ?? "No description added",
                onTap: () => context.pushNamed(AppRoutes.changeDescriptipon),
                hasWarning: true,
              ),
              const Divider(),
              _buildWorkPhotosGallery(context, user),

              if (user.isConsumer != true) ...[
                const Divider(),
                _buildMerchantInfoTile(
                  context,
                  icon: Icons.schedule,
                  title: 'Setup Stripe Merchant Account',
                  subtitle: 'To receive payments',
                  onTap: () {
                    _loginBloc.add(FetchMerchantAccount(context: context));
                  },
                ),
              ],
              const Divider(),
            ],
          ),
        ),
      ],
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
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
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
            Image.asset(AppAssets.arrow),
          ],
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
          Icon(icon, size: 28.sp, color: Colors.grey.shade700),
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

  Widget _buildWorkPhotosGallery(BuildContext context, UserEntity user) {
    return InkWell(
      onTap: () {
        context.pushNamed(AppRoutes.portfolio);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.photo_library_outlined,
                  size: 28.sp,
                  color: Colors.grey.shade700,
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: CustomText(
                    text: 'Work Photos Gallery',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                Image.asset(AppAssets.arrow),
              ],
            ),
            SizedBox(height: 12.h),
            user.media?.isNotEmpty == true
                ? JobImageSlider(showDivider: false, imageUrls: user.media!)
                : Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: CustomText(text: 'No media added '),
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignOutButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: CustomButton(
        text: "Sign out",
        textColor: Colors.white,
        color: AppPalette.primaryColor,
        onPressed: () async {
          context.goNamed(AppRoutes.roleSelection, extra: true);
          // await LocalStorageService().clearAll();
          _loginBloc.add(const LogoutUser());

          debugPrint('Signing out...');
        },
      ),
    );
  }
}
