import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_dimensions.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

class JobImageSlider extends StatelessWidget {
  final List<String> imageUrls;

  const JobImageSlider({super.key, required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingAllSides.w,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(),
              CustomText(
                text: AppTexts.jobImages,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
              Divider(),
            ],
          ),
        ),

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
              final tag = 'job_image_hero_' + index.toString();
              return GestureDetector(
                onTap: () {
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
                      image: DecorationImage(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
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
}

class EnlargedImageView extends StatelessWidget {
  final String imageUrl;
  final String tag;

  const EnlargedImageView({
    super.key,
    required this.imageUrl,
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(
        0.5,
      ), // Lighter backdrop filter effect
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        // Ensure the GestureDetector covers the entire screen
        behavior: HitTestBehavior.opaque,
        child: SizedBox.expand(
          child: Center(child: Hero(tag: tag, child: Image.network(imageUrl))),
        ),
      ),
    );
  }
}
