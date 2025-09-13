import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/asset_paths.dart';
import 'package:help_sum/src/widgets/comman_imageview.dart';
import 'package:help_sum/src/widgets/custom_loading_widget.dart';
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
                  child: Container(color: Colors.black.withValues(alpha: .7)),
                ),
                // Loader container
                Center(
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        10.verticalSpace,
                        Center(child: CustomDotsLoader()),
                        20.verticalSpace,
                        // const CircularProgressIndicator(strokeWidth: 3),
                        // const SizedBox(height: 20),
                        CustomText(
                          text: message,
                          textAlign: TextAlign.center,
                          maxLines: 10,
                          color: Colors.white,
                        ),
                      ],
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
