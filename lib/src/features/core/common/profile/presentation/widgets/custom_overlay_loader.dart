import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/asset_paths.dart';
import 'package:help_sum/src/widgets/comman_imageview.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

class CustomOverlayLoader {
  static OverlayEntry? _overlayEntry;

  /// Show loader with message
  static void show(BuildContext context, {String message = "Please wait..."}) {
    if (_overlayEntry != null) return; // Prevent multiple loaders

    _overlayEntry = OverlayEntry(
      builder:
          (context) => Material(
            color: Colors.black.withValues(alpha: .2),
            child: Stack(
              children: [
                // Dark semi-transparent background
                Positioned.fill(
                  child: AnimatedOpacity(
                    opacity: 1,
                    duration: const Duration(milliseconds: 300),
                    child: Container(color: Colors.black54),
                  ),
                ),
                // Loader container
                Center(
                  child: AnimatedScale(
                    scale: 1.0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutBack,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.symmetric(horizontal: 40),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          10.verticalSpace,
                          CircleAvatar(
                            radius: 50.r,
                            child: CustomImageView(
                              imageType: ImageType.asset,
                              imagePath: AppAssets.appLogo,
                            ),
                          ),
                          20.verticalSpace,
                          const CircularProgressIndicator(strokeWidth: 3),
                          const SizedBox(height: 20),
                          CustomText(
                            text: message,
                            textAlign: TextAlign.center,
                            maxLines: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );

    // Insert overlay
    Overlay.of(context, rootOverlay: true).insert(_overlayEntry!);
  }

  /// Hide loader
  static void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
