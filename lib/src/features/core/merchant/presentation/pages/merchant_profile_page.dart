import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/features/core/merchant/domain/models/service_provider_model.dart';
import 'package:help_sum/src/features/core/merchant/presentation/widgets/about_merchant_widget.dart';
import 'package:help_sum/src/features/core/merchant/presentation/widgets/merchant_details_widget.dart';
import 'package:help_sum/src/features/core/merchant/presentation/widgets/rating_rate_row.dart';
import 'package:help_sum/src/widgets/custom_button.dart';
import 'package:help_sum/src/widgets/image_view.dart';
import 'package:help_sum/src/features/core/merchant/presentation/widgets/merchant_profile_image_view.dart';
import 'package:help_sum/src/features/core/merchant/presentation/widgets/rating_review_section.dart';

class MerchantProfilePage extends StatelessWidget {
  final ServiceProviderModel serviceProvider;

  const MerchantProfilePage({
    super.key,
    required this.serviceProvider,
  });

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
                  height: 250.h,
                  viewportFraction: 1.0,
                  enableInfiniteScroll: false,
                  autoPlay: true,
                ),
                items: serviceProvider.profileImages.map((imageUrl) {
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
              _detailsWidget(),
            ],
          ),
          Positioned(
            top: 190.h,
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
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 70.h),
              MerchantDetailsWidget(
                name: serviceProvider.name,
                profession: serviceProvider.profession,
                isAvailable: serviceProvider.isAvailable,
              ),
              SizedBox(height: 20.h),
              RatingRateRow(
                rating: serviceProvider.rating,
                reviewsCount: serviceProvider.reviewsCount,
              ),
              SizedBox(height: 30.h),
              Divider(color: AppPalette.lightGreyColor, thickness: 1.h),
              SizedBox(height: 20.h),
              AboutMerchantWidget(
                aboutText: serviceProvider.aboutText,
              ),
              SizedBox(height: 30.h),
              RatingReviewSection(
                reviews: serviceProvider.reviews,
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: AppTexts.sendMessage,
                      icon: Icons.message,
                      onPressed: () {
                        // Handle send message
                      },
                      color: AppPalette.primaryColor,
                      textColor: Colors.white,
                      iconColor: Colors.white,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: CustomButton(
                      text: AppTexts.bookNow,
                      icon: Icons.calendar_today,
                      onPressed: () {
                        // Handle book now
                      },
                      color: AppPalette.secondaryColor,
                      textColor: Colors.white,
                      iconColor: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
} 