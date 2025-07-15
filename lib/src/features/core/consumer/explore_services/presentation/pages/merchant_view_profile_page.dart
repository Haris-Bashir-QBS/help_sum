import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/domain/entities/service_provider_model.dart';
import 'package:help_sum/src/features/core/merchant/presentation/widgets/about_merchant_widget.dart';
import 'package:help_sum/src/features/core/merchant/presentation/widgets/merchant_details_widget.dart';
import 'package:help_sum/src/features/core/merchant/presentation/widgets/merchant_info_row.dart';
import 'package:help_sum/src/widgets/custom_button.dart';
import 'package:help_sum/src/widgets/image_view.dart';
import 'package:help_sum/src/features/core/merchant/presentation/widgets/merchant_profile_image_view.dart';
import 'package:help_sum/src/features/core/merchant/presentation/widgets/rating_review_section.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/data/models/route/create_job_route_model.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/presentation/controller/merchant_view_profile_notifier.dart';

class MerchantViewProfilePage extends ConsumerStatefulWidget {
  final CreateJobRouteModel routeModel;
  const MerchantViewProfilePage({super.key, required this.routeModel});

  @override
  ConsumerState<MerchantViewProfilePage> createState() =>
      _MerchantViewProfilePageState();
}

class _MerchantViewProfilePageState
    extends ConsumerState<MerchantViewProfilePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(
      merchantViewProfileProvider(widget.routeModel.merchantId),
    );
    return Scaffold(
      backgroundColor: AppPalette.extraLightGreyColor,
      appBar: AppBar(),
      body: Builder(
        builder: (context) {
          if (profileState is MerchantViewProfileLoading ||
              profileState is MerchantViewProfileInitial) {
            return _buildSkeleton();
          } else if (profileState is MerchantViewProfileError) {
            return Center(child: Text(profileState.message));
          } else if (profileState is MerchantViewProfileLoaded) {
            final serviceProvider = profileState.profile;
            return Stack(
              children: [
                Column(
                  children: [
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 180.h,
                        viewportFraction: 1.0,
                        enableInfiniteScroll: false,
                        autoPlay: true,
                      ),
                      items:
                          serviceProvider.profileImages.map((imageUrl) {
                            return Builder(
                              builder: (BuildContext context) {
                                return ImageView(
                                  imagePath: imageUrl,
                                  height: 250.h,
                                  width: 1.sw,
                                  fit: BoxFit.cover,
                                );
                              },
                            );
                          }).toList(),
                    ),
                    40.verticalSpace,
                    MerchantDetailsWidget(
                      name: serviceProvider.name,
                      profession: serviceProvider.profession,
                      isAvailable: serviceProvider.isAvailable,
                    ),
                    10.verticalSpace,
                    InfoRow(
                      ratePerHour: serviceProvider.rate,
                      averageRating: serviceProvider.rating,
                      distanceKm: serviceProvider.distance,
                      finishedJobs: serviceProvider.completedJobs,
                    ),
                    Divider(thickness: 0.2),
                    _detailsWidget(serviceProvider),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: CustomButton(
                        text: AppTexts.next,
                        color: AppPalette.primaryColor,
                        textColor: Colors.white,
                        iconColor: Colors.white,
                        onPressed: () {
                          context.pushNamed(
                            'createRequest',
                            extra: widget.routeModel,
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
                Positioned(
                  top: 120.h,
                  left: 0,
                  right: 0,
                  child: Align(
                    alignment: Alignment.center,
                    child: MerchantProfileImageView(
                      imagePath: serviceProvider.profileImage,
                      shadowColor: Colors.grey.withAlpha(127),
                    ),
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildSkeleton() {
    return Skeletonizer(
      enabled: true,
      child: Stack(
        children: [
          Column(
            children: [
              Container(height: 180.h, width: 1.sw, color: Colors.white),
              40.verticalSpace,
              Container(height: 24.h, width: 120.w, color: Colors.white),
              10.verticalSpace,
              Container(height: 20.h, width: 200.w, color: Colors.white),
              Divider(thickness: 0.2),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 0.h),
                      Container(height: 60.h, width: 1.sw, color: Colors.white),
                      Divider(thickness: 0.3),
                      Container(height: 80.h, width: 1.sw, color: Colors.white),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 120.h,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.center,
              child: CircleAvatar(radius: 60.r, backgroundColor: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailsWidget(ServiceProviderModel serviceProvider) {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 0.h),
              AboutMerchantWidget(aboutText: serviceProvider.aboutText),
              Divider(thickness: 0.3),
              RatingReviewSection(reviews: serviceProvider.reviews),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
