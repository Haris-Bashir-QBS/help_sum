import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_dimensions.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/widgets/custom_text.dart';
import 'package:help_sum/src/widgets/enlarged_image_view_widget.dart';

class JobImageSlider extends StatelessWidget {
  final List<String> imageUrls;
  final bool showDivider;

  const JobImageSlider({
    super.key,
    required this.imageUrls,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showDivider) ...[
          Divider(),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingAllSides.w,
            ),
            child: CustomText(
              text: AppTexts.jobImages,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Divider(),
          5.verticalSpace,
        ],
        5.verticalSpace,
        SizedBox(
          height: 100.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: imageUrls.length,
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingAllSides.w,
            ),
            itemBuilder: (context, index) {
              final imageUrl = imageUrls[index];
              final tag = 'job_image_hero_$index';

              return GestureDetector(
                onTap: () {
                  _viewFullImageNavigation(context, imageUrl, tag);
                },
                child: Hero(
                  tag: tag,
                  child: Container(
                    margin: EdgeInsets.only(right: 10.w),
                    width: 100.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.appBorderRadius.r,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.appBorderRadius.r,
                      ),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;

                          return _buildShimmerPlaceholder();
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return _buildErrorPlaceholder();
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildShimmerPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.appBorderRadius.r),
        gradient: LinearGradient(
          colors: [Colors.grey[300]!, Colors.grey[100]!, Colors.grey[300]!],
          stops: const [0.4, 0.5, 0.6],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Icon(Icons.image, color: Colors.grey[400], size: 30.w),
      ),
    );
  }

  Widget _buildErrorPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(AppDimensions.appBorderRadius.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.broken_image, color: Colors.grey[600], size: 30.w),
          2.verticalSpace,
          Text(
            'Failed to load',
            style: TextStyle(color: Colors.grey[600], fontSize: 8.sp),
          ),
        ],
      ),
    );
  }

  void _viewFullImageNavigation(
    BuildContext context,
    String imageUrl,
    String tag,
  ) {
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return EnlargedImageView(imageUrl: imageUrl, tag: tag);
        },
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }
}
