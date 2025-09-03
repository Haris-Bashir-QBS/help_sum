import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

class ServiceCard extends StatelessWidget {
  final String title;
  final String? photo;
  final IconData? icon;
  final VoidCallback onTap;
  final bool glassmorphic;

  const ServiceCard({
    super.key,
    required this.title,
    this.photo,
    this.icon,
    required this.onTap,
    this.glassmorphic = false,
  });

  /// ✅ Named constructor for glassmorphic version
  factory ServiceCard.glassmorphic({
    required String title,
    String? photo,
    IconData? icon,
    required VoidCallback onTap,
  }) {
    return ServiceCard(
      title: title,
      photo: photo,
      icon: icon,
      onTap: onTap,
      glassmorphic: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: glassmorphic ? _buildGlassCard() : _buildNormalCard(),
    );
  }

  Widget _buildIconOrPhoto({required Color color}) {
    print("Here it is inside icon section$icon");
    try {
      if (photo != null && photo!.isNotEmpty) {
        print("Here it is inside phot section $photo");
        return Image.network(
          photo!,
          width: 40,
          height: 40,
          color: color == Colors.white ? Colors.white : null,
          errorBuilder: (context, error, stackTrace) {
            return Icon(Icons.photo, size: 40.sp, color: color);
          },
        );
      } else if (icon != null) {
        print("Here it is inside icon section$icon");
        return Icon(icon, size: 40.sp, color: color);
      } else {
        print("Here it is inside default icon section");
        return Icon(Icons.photo, size: 40.sp, color: color);
      }
    } catch (e) {
      return Icon(Icons.photo, size: 40.sp, color: color);
    }
  }

  /// 🌟 Normal White Card
  Widget _buildNormalCard() {
    return Card(
      color: Colors.white,
      elevation: 8.0,
      margin: EdgeInsets.zero,
      shadowColor: Colors.black.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0.r)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildIconOrPhoto(color: Colors.grey[600]!),
          SizedBox(height: 5.0.h),
          CustomText(
            text: title,
            textAlign: TextAlign.center,
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  /// 🌟 Glassmorphic Primary Background Card
  Widget _buildGlassCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14.0.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Container(
          decoration: BoxDecoration(
            color: AppPalette.primaryColor.withOpacity(0.65), // glass effect
            borderRadius: BorderRadius.circular(14.0.r),
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildIconOrPhoto(color: Colors.white),
              SizedBox(height: 5.0.h),
              CustomText(
                text: title,
                textAlign: TextAlign.center,
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
