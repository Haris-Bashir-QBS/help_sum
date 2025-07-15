import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:help_sum/src/core/constants/app_dimensions.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/presentation/widgets/recommended_service_provider_card.dart';

class MerchantListShimmer extends StatelessWidget {
  const MerchantListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingAllSides.w,
          vertical: 10.h,
        ),
        itemCount: 6,
        itemBuilder:
            (context, index) => RecommendedServiceProviderCard(
              name: '',
              rating: '',
              distance: '',
              pricePerHour: '',
              imageUrl: '',
              onTap: () {},
            ),
        separatorBuilder: (context, index) => 10.verticalSpace,
      ),
    );
  }
}
