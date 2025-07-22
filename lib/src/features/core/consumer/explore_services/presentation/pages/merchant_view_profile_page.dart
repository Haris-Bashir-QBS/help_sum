import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/router/app_routes.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/presentation/controller/merchant_view_profile_provider.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/presentation/controller/merchant_view_profile_state.dart';
import 'package:help_sum/src/features/core/merchant/presentation/widgets/about_merchant_widget.dart';
import 'package:help_sum/src/features/core/merchant/presentation/widgets/merchant_details_widget.dart';
import 'package:help_sum/src/features/core/merchant/presentation/widgets/merchant_info_row.dart';
import 'package:help_sum/src/widgets/custom_button.dart';
import 'package:help_sum/src/widgets/image_view.dart';
import 'package:help_sum/src/features/core/merchant/presentation/widgets/merchant_profile_image_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:help_sum/src/widgets/no_data_found.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/data/models/route/create_job_route_model.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

import '../../../../../auth/data/models/response/user_model.dart';

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
    Future.microtask(() {
      ref
          .read(
            merchantViewProfileProvider(widget.routeModel.merchantId).notifier,
          )
          .fetchProfile(widget.routeModel.merchantId);
    });
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
                    // IMAGE CAROUSEL OR PLACEHOLDER
                    serviceProvider.media?.isNotEmpty == true
                        ? CarouselSlider(
                          options: CarouselOptions(
                            height: 180.h,
                            viewportFraction: 1.0,
                            enableInfiniteScroll: false,
                            autoPlay: true,
                          ),
                          items:
                              serviceProvider.media?.map((imageUrl) {
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
                        )
                        : Container(
                          height: 180.h,
                          width: 1.sw,
                          color: AppPalette.darkGreyColor.withAlpha(150),
                          child: Center(
                            child: Icon(
                              Icons.image_not_supported,
                              size: 60,
                              color: AppPalette.lightGreyColor,
                            ),
                          ),
                        ),
                    50.verticalSpace,
                    MerchantDetailsWidget(
                      name:
                          "${serviceProvider.firstName ?? ""}${serviceProvider.lastName ?? ""}",
                      profession: serviceProvider.role ?? "",
                      isAvailable: true,
                    ),
                    10.verticalSpace,
                    InfoRow(
                      ratePerHour: serviceProvider.hourlyRate?.toString() ?? "",
                      averageRating: serviceProvider.rating ?? "0",
                      distanceKm: "",
                      finishedJobs: serviceProvider.totalJobsCompleted ?? "0",
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
                            AppRoutes.createRequest,
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
                      imagePath: serviceProvider.image ?? "",
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

  Widget _detailsWidget(UserModel serviceProvider) {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 0.h),
              AboutMerchantWidget(aboutText: serviceProvider.description ?? ""),
              Divider(thickness: 0.3),
              CustomText(
                text: AppTexts.reviews,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
              // serviceProvider.reviews.isNotEmpty
              //     ? RatingReviewSection(reviews: serviceProvider.reviews)
              //     :
              Padding(
                padding: EdgeInsets.only(top: 60.h),
                child: Center(child: NoDataFound(message: "No Reviews Found")),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
