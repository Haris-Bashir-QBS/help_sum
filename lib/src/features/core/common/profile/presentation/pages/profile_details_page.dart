import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/constants/app_role.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/constants/asset_paths.dart';
import 'package:help_sum/src/core/router/app_routes.dart';
import 'package:help_sum/src/features/auth/domain/entities/user_entity.dart';
import 'package:help_sum/src/features/auth/presentation/controller/notifiers/auth_notifier.dart';
import 'package:help_sum/src/features/auth/presentation/controller/notifiers/auth_state.dart';
import 'package:help_sum/src/features/auth/presentation/screens/stripe_merchant_setup_screen.dart';
import 'package:help_sum/src/features/core/common/profile/presentation/controller/user_state_provider.dart';
import 'package:help_sum/src/features/core/common/profile/presentation/widgets/info_card.dart';
import 'package:help_sum/src/features/core/common/profile/presentation/widgets/info_row.dart';
import 'package:help_sum/src/features/core/common/profile/presentation/widgets/profile_header.dart';
import 'package:help_sum/src/features/core/consumer/booking/presentation/widgets/job_image_slider.dart';
import 'package:help_sum/src/widgets/custom_button.dart';
import 'package:help_sum/src/widgets/custom_text.dart';
import 'package:help_sum/src/widgets/modal_progress_hud.dart';

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
          print("userRole  is ${user?.role}");
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
                                ProfileHeader(user: user),
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
        // InfoRow(
        //   label: AppTexts.emailAddress,
        //   value: user.emailAddress,
        //   labelWidget: VerificationStatusIndicator(isVerified: user.isVerified),
        // ),
        InfoRow(label: AppTexts.phoneNumber, value: user.phone ?? ""),
      ],
      onPressed: () {
        context.pushNamed(AppRoutes.editBasicInfo, extra: user);
      },
    );
  }

  Widget _buildMerchantProfileHeader(BuildContext context, UserEntity user) {
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
            _buildAvatarWithBadge(),
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
                    ? user.services!.map((e) => e['name']).join(',').toString()
                    : 'No Services Added',
            onTap: () => context.pushNamed(AppRoutes.selectSkill, extra: true),
          ),
          const Divider(),
          _buildMerchantInfoTile(
            context,
            icon: Icons.schedule,
            title: 'Schedule',
            subtitle: 'Todays: 9:00AM - 4:00PM',
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

          if (user.isMerchant == false)
            _buildMerchantInfoTile(
              context,
              icon: Icons.schedule,
              title: 'Setup Stripe Merchant Account',
              subtitle: 'to recieve payments',
              onTap: () async {
                final checkoutUrl = await ref
                    .read(authNotifierProvider.notifier)
                    .fetchStripeAccount(context);

                if (checkoutUrl.isNotEmpty) {
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
                    // Handle the result if needed
                    print("Stripe setup completed with result: $result");
                  }
                }
              },
            ),
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
                  CustomText(text: title, fontWeight: FontWeight.bold),
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
    return Stack(
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
                  child: Text(
                    'Work Photos Gallery',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
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
        color: const Color(0xFF0D6EFD),
        onPressed: () {
          context.pushNamed(AppRoutes.roleSelection, extra: true);
          debugPrint('Signing out...');
        },
      ),
    );
  }
}
