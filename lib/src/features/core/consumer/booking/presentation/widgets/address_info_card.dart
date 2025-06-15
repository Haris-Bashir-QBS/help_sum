import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_dimensions.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

class AddressInfoCard extends StatelessWidget {
  final String address;
  final VoidCallback? onLocationTap;
  final VoidCallback? onMapTap;

  const AddressInfoCard({
    super.key,
    required this.address,
    this.onLocationTap,
    this.onMapTap,
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
          Divider(),
          CustomText(
            text: AppTexts.address,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
          Divider(),
          10.verticalSpace,
          Row(
            children: [
              Expanded(child: CustomText(text: address, fontSize: 16.sp)),
              IconButton(
                icon: Icon(
                  Icons.location_on_outlined,
                  color: AppPalette.blackColor,
                ),
                onPressed: onLocationTap,
              ),
              IconButton(
                icon: Icon(Icons.map_outlined, color: AppPalette.blackColor),
                onPressed: onMapTap,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
