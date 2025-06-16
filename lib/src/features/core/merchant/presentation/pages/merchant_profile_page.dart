import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/features/core/merchant/domain/models/service_provider_model.dart';
import 'package:help_sum/src/features/core/merchant/presentation/widgets/about_merchant_widget.dart';
import 'package:help_sum/src/features/core/merchant/presentation/widgets/merchant_details_widget.dart';
import 'package:help_sum/src/features/core/merchant/presentation/widgets/merchant_info_row.dart';
import 'package:help_sum/src/widgets/custom_button.dart';
import 'package:help_sum/src/widgets/image_view.dart';
import 'package:help_sum/src/features/core/merchant/presentation/widgets/merchant_profile_image_view.dart';
import 'package:help_sum/src/features/core/merchant/presentation/widgets/rating_review_section.dart';

class MerchantProfilePage extends StatelessWidget {
  final ServiceProviderModel serviceProvider;

  const MerchantProfilePage({super.key, required this.serviceProvider});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.extraLightGreyColor,
      appBar: AppBar(),
      body: Stack(
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
                ratePerHour: 250,
                averageRating: 4.4,
                distanceKm: 5.5,
                finishedJobs: 24,
              ),
              Divider(thickness: 0.2),

              _detailsWidget(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: CustomButton(
                  text: AppTexts.next,
                  // icon: Icons.message,
                  color: AppPalette.primaryColor,
                  textColor: Colors.white,
                  iconColor: Colors.white,
                  onPressed: () {
                    // Handle send message
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
      ),
    );
  }

  Expanded _detailsWidget() {
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
