import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_dimensions.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/data/models/response/merchant_response_model.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/presentation/widgets/recommended_service_provider_card.dart';

class MerchantTabView extends StatelessWidget {
  final List<MerchantModel> merchants;
  final ScrollController? scrollController;
  final bool hasMore;
  final Function(MerchantModel) onMerchantTap;
  final VoidCallback? onEndReached;

  const MerchantTabView({
    super.key,
    required this.merchants,
    required this.onMerchantTap,
    this.scrollController,
    this.hasMore = false,
    this.onEndReached,
  });

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.pixels >=
                notification.metrics.maxScrollExtent - 200 &&
            hasMore &&
            onEndReached != null) {
          onEndReached!();
        }
        return false;
      },
      child: ListView.separated(
        controller: scrollController,
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingAllSides.w,
          vertical: 10.h,
        ),
        itemCount: merchants.length + (hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == merchants.length && hasMore) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
            );
          }
          final merchant = merchants[index];
          return RecommendedServiceProviderCard(
            name: '${merchant.firstName} ${merchant.lastName}',
            rating: 'N/A',
            distance: 'N/A',
            pricePerHour: '\$ ${merchant.hourlyRate} per hour',
            imageUrl:
                merchant.image ??
                (merchant.media.isNotEmpty ? merchant.media.first : ''),
            onTap: () {
              onMerchantTap(merchant);
            },
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return 10.verticalSpace;
        },
      ),
    );
  }
}
