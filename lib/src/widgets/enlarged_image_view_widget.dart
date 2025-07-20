import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      backgroundColor: Colors.black.withOpacity(0.3),
      body: GestureDetector(
        onTap: () => Navigator.pop(context),
        behavior: HitTestBehavior.opaque,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Blurred background
            Positioned.fill(
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(color: Colors.black.withOpacity(0.2)),
              ),
            ),

            // Zoomable image
            Center(
              child: Hero(
                tag: tag,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: InteractiveViewer(
                    minScale: 1,
                    maxScale: 4,
                    panEnabled: true,
                    child: Image.network(imageUrl),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
