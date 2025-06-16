import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/constants/app_role.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/constants/asset_paths.dart';
import 'package:help_sum/src/core/router/app_routes.dart';
import 'package:help_sum/src/features/core/common/profile/models/user_model.dart';
import 'package:help_sum/src/features/core/common/profile/widgets/info_card.dart';
import 'package:help_sum/src/features/core/common/profile/widgets/info_row.dart';
import 'package:help_sum/src/features/core/common/profile/widgets/profile_header.dart';
import 'package:help_sum/src/features/core/common/profile/widgets/verification_status.dart';
import 'package:help_sum/src/features/core/consumer/booking/presentation/widgets/job_image_slider.dart';
import 'package:help_sum/src/widgets/custom_button.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

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
    // NOTE: The merchant UI screenshot has a distinct page structure:
    // 1. A dark green background for the whole screen.
    // 2. A large "Account" title at the top.
    // 3. The main content is inside a white container with rounded top corners.
    // To achieve this, the Scaffold that displays this page should be configured accordingly.
    // The code below implements the *content* of the merchant's profile page.

    return SafeArea(
      child: Column(
        children: [
          Expanded(
            // To match the screenshot exactly, this SingleChildScrollView
            // should be wrapped in a Container with a white background
            // and rounded top corners.
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children:
                    appRole == AppRole.consumer
                        ? [
                          _buildProfileHeader(),
                          SizedBox(height: 24.h),
                          _buildBasicInfoCard(context),
                          26.verticalSpace,
                          _buildContactInfoCard(context),
                        ]
                        : [
                          // --- START OF MERCHANT UI CODE ---
                          _buildMerchantProfileHeader(context),

                          SizedBox(height: 16.h),
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFF9F9F9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Column(
                              children: [
                                // const Divider(),
                                _buildMerchantInfoTile(
                                  context,
                                  icon: Icons.monetization_on_outlined,
                                  title: 'Rates Per hour',
                                  subtitle: '\$1200/hr',
                                  onTap: () {
                                    context.pushNamed(AppRoutes.rates);
                                  },
                                ),
                                const Divider(),
                                _buildMerchantInfoTile(
                                  context,
                                  icon: Icons.diamond_outlined,
                                  title: 'Skill',
                                  subtitle: 'Mechanic, Tyre Change',
                                  onTap: () {
                                    context.pushNamed(
                                      AppRoutes.selectSkill,
                                      extra: true,
                                    );
                                  },
                                ),
                                const Divider(),
                                _buildMerchantInfoTile(
                                  context,
                                  icon: Icons.schedule,
                                  title: 'Schedule',
                                  subtitle: 'Todays: 9:00AM - 4:00PM',
                                  onTap: () {
                                    context.pushNamed(
                                      AppRoutes.createSchedule,
                                      extra: true,
                                    );
                                  },
                                ),
                                const Divider(),
                                _buildMerchantInfoTile(
                                  context,
                                  icon: Icons.description_outlined,
                                  title: 'Description',
                                  subtitle:
                                      'I am a Mechanic who fixes vehicles a...',
                                  onTap: () {
                                    context.pushNamed(
                                      AppRoutes.changeDescriptipon,
                                    );
                                  },
                                  hasWarning: true,
                                ),
                                const Divider(),
                                _buildWorkPhotosGallery(context),
                              ],
                            ),
                          ),
                          // --- END OF MERCHANT UI CODE ---
                        ],
              ),
            ),
          ),
          _buildSignOutButton(context),
        ],
      ),
    );
  }

  // Original Consumer Widgets (keep them as they are)
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

  // --- NEW WIDGETS FOR MERCHANT UI ---

  Widget _buildMerchantProfileHeader(BuildContext context) {
    return InkWell(
      onTap: () {
        context.pushNamed(AppRoutes.editBasicInfo, extra: user.copyWith());
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
                  CustomText(
                    text: title,
                    fontWeight: FontWeight.bold,
                    // style: TextStyle(
                    //   fontSize: 16.sp,
                    //   fontWeight: FontWeight.w500,
                    //   color: Colors.black,
                    // ),
                  ),
                  SizedBox(height: 10.h),
                  CustomText(
                    text: subtitle,
                    maxLines: 1,
                    fontSize: 15.sp,

                    // overflow: TextOverflow.ellipsis,
                    // style: TextStyle(
                    //   fontSize: 14.sp,
                    //   color: Colors.grey.shade200,
                    // ),
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

  Widget _buildWorkPhotosGallery(BuildContext context) {
    // Replace with your actual image assets or network URLs.
    final List<String> images = [
      'https://picsum.photos/id/237/200/300',
      'https://picsum.photos/id/237/200/300',
      'https://picsum.photos/id/237/200/300',
      'https://picsum.photos/id/237/200/300',
      'https://picsum.photos/id/237/200/300',
    ];

    return InkWell(
      onTap: () => debugPrint('Gallery Tapped'),
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

            JobImageSlider(
              showDivider: false,
              imageUrls: [
                'https://picsum.photos/id/237/200/300',
                'https://picsum.photos/id/238/200/300',
                'https://picsum.photos/id/239/200/300',
                'https://picsum.photos/id/240/200/300',
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Updated Sign Out button to match the blue color in the screenshot
  Widget _buildSignOutButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: CustomButton(
        text: "Sign out", // Use hardcoded text from screenshot
        textColor: Colors.white,
        color: const Color(0xFF0D6EFD), // Blue color from screenshot
        onPressed: () {
          debugPrint('Signing out...');
          // context.pushNamed(AppRoutes.paymentResult, extra: true);
        },
      ),
    );
  }
}
