import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/utils/app_static_data.dart';
import 'package:help_sum/src/widgets/custom_app_bar.dart';

class AllServiceProvidersListingPage extends StatelessWidget {
  const AllServiceProvidersListingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: AppTexts.allServiceProviders,
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(16.w),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Adjust as needed for service providers layout
          crossAxisSpacing: 10.w,
          mainAxisSpacing: 10.h,
          childAspectRatio:
              0.8, // Adjust aspect ratio for service provider cards
        ),
        itemCount: AppStaticData.serviceProviders.length,
        itemBuilder: (context, index) {
          final provider = AppStaticData.serviceProviders[index];
          return Container();
          //           return ServiceProviderCard(title: provider.name, reviews: provider.reviews.length.toString(),
          //            onTap: () {
          // context.pushNamed(AppRoutes.merchantProfile,extra: provider);
          //            },);
        },
      ),
    );
  }
}
