import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_role.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/constants/asset_paths.dart';
import 'package:help_sum/src/core/extensions/context_extensions.dart';
import 'package:help_sum/src/core/router/app_routes.dart';
import 'package:help_sum/src/core/services/local_storage_service.dart';
import 'package:help_sum/src/core/utils/app_utils.dart';
import 'package:help_sum/src/features/auth/data/models/response/user_model.dart';
import 'package:help_sum/src/features/auth/domain/entities/user_entity.dart';
import 'package:help_sum/src/features/auth/presentation/controller/notifiers/auth_notifier.dart';
import 'package:help_sum/src/features/auth/presentation/controller/notifiers/auth_state.dart';
import 'package:help_sum/src/features/auth/presentation/screens/stripe_merchant_setup_page.dart';
import 'package:help_sum/src/features/core/common/profile/presentation/controller/user_state_provider.dart';
import 'package:help_sum/src/features/core/common/profile/presentation/widgets/info_card.dart';
import 'package:help_sum/src/features/core/common/profile/presentation/widgets/info_row.dart';
import 'package:help_sum/src/features/core/common/profile/presentation/widgets/profile_header.dart';
import 'package:help_sum/src/features/core/common/profile/presentation/widgets/verification_status.dart';
import 'package:help_sum/src/features/core/consumer/booking/presentation/widgets/job_image_slider.dart';
import 'package:help_sum/src/widgets/custom_button.dart';
import 'package:help_sum/src/widgets/custom_text.dart';
import 'package:help_sum/src/widgets/modal_progress_hud.dart';
import 'package:help_sum/src/features/core/common/profile/presentation/widgets/avatar_with_badge.dart';

class ProfileDetailsPage extends ConsumerStatefulWidget {
  const ProfileDetailsPage({super.key});

  @override
  ConsumerState<ProfileDetailsPage> createState() => _ProfileDetailsPageState();
}

class _ProfileDetailsPageState extends ConsumerState<ProfileDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer(
        builder: (context, ref, _) {
          UserEntity? user = ref.watch(currentUserProvider).user;
          debugPrint("userRole  is ${user?.role}");
          if (user == null) {
            return Container(color: Colors.red, width: 1.sw, height: 200.h);
          }

          return ModalProgressHUD(
            inAsyncCall:
                ref.watch(authNotifierProvider.notifier)
                    is MerchantSetupLoading,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      children:
                          user.role == AppRole.consumer.name
                              ? [
                                _buildMerchantProfileHeader(
                                  context,
                                  user,
                                  showRating: false,
                                ),
                                SizedBox(height: 24.h),
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
                _buildSignOutButton(context),
              ],
            ),
          );
        },
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
        context.pushNamed(AppRoutes.editBasicInfo, extra: user);
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
        context.pushNamed(AppRoutes.editBasicInfo, extra: user);
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
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
        decoration: BoxDecoration(
          color: const Color(0xffF5F5F5),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            const AvatarWithBadge(),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${user.firstName} ${user.lastName}",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (showRating ?? true) ...[
                    Row(
                      children: [
                        ...List.generate(
                          4,
                          (i) => Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 16.sp,
                          ),
                        ),
                        Icon(Icons.star_half, color: Colors.amber, size: 16.sp),
                        SizedBox(width: 4.w),
                        CustomText(text: user.rating ?? "N/A"),
                      ],
                    ),
                  ],
                  SizedBox(height: 4.h),
                ],
              ),
            ),
            Image.asset(AppAssets.arrow),
          ],
        ),
      ),
    );
  }

  Widget _buildMerchantDetails(BuildContext context, UserEntity user) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(12),
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
                    ? user.services!.map((e) => e['name']).join(', ').toString()
                    : 'No Services Added',
            onTap: () => context.pushNamed(AppRoutes.selectSkill, extra: true),
          ),
          const Divider(),
          _buildMerchantInfoTile(
            context,
            icon: Icons.schedule,
            title: 'Schedule',
            subtitle: AppUtils.getTodayScheduleSubtitle(user),
            onTap:
                () => context.pushNamed(AppRoutes.createSchedule, extra: true),
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
              onTap: () async {
                final checkoutUrl = await ref
                    .read(authNotifierProvider.notifier)
                    .fetchStripeAccount(context);

                if (checkoutUrl.isNotEmpty) {
                  //if (mounted) {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              StripeMerchantSetupScreen(setupUrl: checkoutUrl),
                    ),
                  );

                  if (result != null && result == true) {
                    final updatedUser = user.copyWith(isMerchant: true);
                    ref
                        .read(currentUserProvider.notifier)
                        .updateUser(updatedUser);
                    debugPrint("Stripe setup completed with result: $result");
                  }
                  //}
                }
              },
            ),
          ],
          const Divider(),
        ],
      ),
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
      padding: EdgeInsets.all(16.w),
      child: CustomButton(
        text: "Sign out",
        textColor: Colors.white,
        color: AppPalette.primaryColor,
        onPressed: () async {
          context.goNamed(AppRoutes.roleSelection, extra: true);
          await LocalStorageService().clearAll();
          ref.read(currentUserProvider.notifier).clearUser();
          debugPrint('Signing out...');
        },
      ),
    );
  }
}
