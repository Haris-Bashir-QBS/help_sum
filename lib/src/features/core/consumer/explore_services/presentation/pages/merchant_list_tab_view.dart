import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_dimensions.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/data/models/response/merchant_response_model.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/presentation/widgets/recommended_service_provider_card.dart';
import 'package:help_sum/src/widgets/custom_refresh_indicator.dart';

class MerchantTabView extends StatelessWidget {
  final List<MerchantModel> merchants;
  final ScrollController? scrollController;
  final bool hasMore;
  final Function(MerchantModel) onMerchantTap;
  final VoidCallback? onEndReached;
  final Future<void> Function() onRefresh;

  const MerchantTabView({
    super.key,
    required this.merchants,
    required this.onMerchantTap,
    required this.onRefresh,
    this.scrollController,
    this.hasMore = false,
    this.onEndReached,
  });

  @override
  Widget build(BuildContext context) {
    // Show no data widget if merchants list is empty
    if (merchants.isEmpty) {
      return CustomRefreshIndicator(
        onRefresh: onRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: const NoMerchantsWidget(),
          ),
        ),
      );
    }

    return CustomRefreshIndicator(
      onRefresh: onRefresh,
      child: NotificationListener<ScrollNotification>(
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
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingAllSides.w,
            vertical: 10.h,
          ),
          itemCount: merchants.length + (hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == merchants.length && hasMore) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: const CircularProgressIndicator(),
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
      ),
    );
  }
}

class NoMerchantsWidget extends StatelessWidget {
  const NoMerchantsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_off_outlined,
            size: 80.sp,
            color: Colors.grey[400],
          ),
          20.verticalSpace,
          Text(
            'No Service Providers Found',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          10.verticalSpace,
          Text(
            'Try searching in a different area or\ncheck back later for new providers',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[500],
              height: 1.4,
            ),
          ),
          30.verticalSpace,
          // ElevatedButton.icon(
          //   onPressed: () {
          //     // You can add refresh functionality here if needed
          //   },
          //   icon: const Icon(Icons.refresh),
          //   label: const Text('Refresh'),
          //   style: ElevatedButton.styleFrom(
          //     padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(8.r),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
