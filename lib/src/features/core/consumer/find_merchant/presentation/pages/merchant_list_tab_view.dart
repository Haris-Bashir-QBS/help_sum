import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_dimensions.dart';
import 'package:help_sum/src/features/core/consumer/find_merchant/presentation/widgets/recommended_service_provider_card.dart';

class MerchantTabView extends StatelessWidget {
  final List<Map<String, String>> merchants;

  const MerchantTabView({super.key, required this.merchants});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingAllSides.w,
        vertical: 10.h,
      ),
      itemCount: merchants.length,
      itemBuilder: (context, index) {
        final merchant = merchants[index];
        return RecommendedServiceProviderCard(
          name: merchant['name']!,
          rating: merchant['rating']!,
          distance: merchant['distance']!,
          pricePerHour: merchant['price']!,
          imageUrl: merchant['imageUrl']!,
          onTap: () {},
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return 10.verticalSpace;
      },
    );
  }
}
