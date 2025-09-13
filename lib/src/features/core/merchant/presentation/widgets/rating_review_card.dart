import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/widgets/custom_text.dart';
import 'package:help_sum/src/widgets/comman_imageview.dart';

class RatingReviewCard extends StatefulWidget {
  final String reviewerName;
  final double rating;
  final String reviewText;
  final String date;
  final String? reviewerImage;
  final List<String>? images;

  const RatingReviewCard({
    super.key,
    required this.reviewerName,
    required this.rating,
    required this.reviewText,
    required this.date,
    this.reviewerImage,
    this.images,
  });

  @override
  State<RatingReviewCard> createState() => _RatingReviewCardState();
}

class _RatingReviewCardState extends State<RatingReviewCard>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _shimmerController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    
    // Start shimmer animation
    _shimmerController.repeat();
    
    // Start fade animation after a short delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _fadeController.forward();
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppPalette.extraLightGreyColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4.r,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Reviewer row
          Row(
            children: [
              _buildAnimatedAvatar(),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: widget.reviewerName,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    CustomText(
                      text: _formatDate(widget.date),
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 10.h),

          // Rating bar
          RatingBarIndicator(
            rating: widget.rating,
            itemBuilder:
                (context, index) => const Icon(Icons.star, color: Colors.amber),
            itemCount: 5,
            itemSize: 20.sp,
            unratedColor: Colors.grey[300],
            direction: Axis.horizontal,
          ),

          SizedBox(height: 10.h),

          // Review text
          if (widget.reviewText.isNotEmpty)
            CustomText(text: widget.reviewText, fontSize: 14.sp, maxLines: 5),

          // Images section
          if (widget.images != null && widget.images!.isNotEmpty) ...[
            SizedBox(height: 10.h),
            SizedBox(
              height: 80.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.images!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: GestureDetector(
                      onTap: () {
                        // Navigate to enlarged image view
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Scaffold(
                              appBar: AppBar(
                                backgroundColor: Colors.black,
                                iconTheme: const IconThemeData(color: Colors.white),
                              ),
                              backgroundColor: Colors.black,
                              body: Center(
                                child: CustomImageView(
                                  imageType: ImageType.network,
                                  imagePath: widget.images![index],
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: 80.w,
                        height: 80.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: CustomImageView(
                            imageType: ImageType.network,
                            imagePath: widget.images![index],
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
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        return 'Today';
      } else if (difference.inDays == 1) {
        return 'Yesterday';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      } else {
        return '${date.day}/${date.month}/${date.year}';
      }
    } catch (e) {
      return dateString;
    }
  }

  Widget _buildAnimatedAvatar() {
    return Container(
      width: 60.w,
      height: 60.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            AppPalette.primaryColor.withOpacity(0.1),
            AppPalette.primaryColor.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Shimmer effect while loading
          if (widget.reviewerImage != null && widget.reviewerImage!.isNotEmpty)
            AnimatedBuilder(
              animation: _shimmerController,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Colors.grey[300]!,
                        Colors.grey[100]!,
                        Colors.grey[300]!,
                      ],
                      stops: [
                        _shimmerController.value - 0.3,
                        _shimmerController.value,
                        _shimmerController.value + 0.3,
                      ].map((e) => e.clamp(0.0, 1.0)).toList(),
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                );
              },
            ),
          
          // Actual image with fade animation
          if (widget.reviewerImage != null && widget.reviewerImage!.isNotEmpty)
            FadeTransition(
              opacity: _fadeAnimation,
              child: CircleAvatar(
                radius: 30.r,
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(widget.reviewerImage!),
                onBackgroundImageError: (exception, stackTrace) {
                  // Handle image loading error
                  if (mounted) {
                    _fadeController.forward();
                  }
                },
                child: null,
              ),
            )
          else
            // Default avatar when no image
            CircleAvatar(
              radius: 30.r,
              backgroundColor: AppPalette.primaryColor.withOpacity(0.1),
              child: Icon(
                Icons.person,
                size: 30.sp,
                color: AppPalette.primaryColor,
              ),
            ),
        ],
      ),
    );
  }
}
