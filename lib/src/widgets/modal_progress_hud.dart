import "dart:ui";

import "package:flutter/material.dart";
import "package:help_sum/src/core/constants/app_palette.dart";
import "package:help_sum/src/widgets/custom_circular_progress_indicator.dart";
import "package:help_sum/src/widgets/custom_loading_widget.dart";

class ModalProgressHUD extends StatelessWidget {
  final bool inAsyncCall;
  final double opacity;
  final Color color;
  final Widget progressIndicator;
  final Offset? offset;
  final bool dismissible;
  final Widget child;
  final double blur;

  const ModalProgressHUD({
    super.key,
    required this.inAsyncCall,
    this.opacity = 0.3,
    this.color = Colors.grey,
    this.progressIndicator = const CustomCircularProgressIndicator(),
    this.offset,
    this.dismissible = false,
    required this.child,
    this.blur = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    Widget layOutProgressIndicator;
    if (offset == null) {
      layOutProgressIndicator = Center(child: progressIndicator);
    } else {
      layOutProgressIndicator = Positioned(
        left: offset!.dx,
        top: offset!.dy,
        child: progressIndicator,
      );
    }

    return Stack(
      children: [
        child,
        if (inAsyncCall) ...[
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
            child: Opacity(
              opacity: opacity,
              child: ModalBarrier(dismissible: dismissible, color: color),
            ),
          ),

          Align(
            alignment: Alignment.center,
            child: CustomDotsLoader(
              dot1Color: AppPalette.starColor,
              dot2Color: AppPalette.infoColor,
              size: 60,
            ),
          ),

          // layOutProgressIndicator,
        ],
      ],
    );
  }
}
