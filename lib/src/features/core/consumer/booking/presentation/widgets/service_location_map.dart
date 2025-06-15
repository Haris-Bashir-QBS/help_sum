import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_dimensions.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

class ServiceLocationMap extends StatelessWidget {
  final double latitude;
  final double longitude;

  const ServiceLocationMap({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingAllSides,
          ).r,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: AppTexts.serviceLocation,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
          10.verticalSpace,
          Container(
            height: 200.h,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                AppDimensions.appBorderRadius.r,
              ),
              color: Colors.grey[300],
              // image: const DecorationImage(
              //   image: NetworkImage(
              //     'https://maps.googleapis.com/maps/api/staticmap?center=34.0151,-118.4912&zoom=14&size=400x200',
              //   ), // Removed API key
              //   fit: BoxFit.cover,
              // ),
            ),
            child: Center(
              child: Icon(Icons.location_on, color: Colors.red, size: 40.sp),
            ),
          ),
        ],
      ),
    );
  }
}
