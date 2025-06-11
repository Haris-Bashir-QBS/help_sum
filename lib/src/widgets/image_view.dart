import 'package:flutter/material.dart';

class ImageView extends StatelessWidget {
  final String imagePath;
  final double? height;
  final double? width;
  final BoxFit? fit;

  const ImageView({
    super.key,
    required this.imagePath,
    this.height,
    this.width,
    this.fit,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imagePath,
      height: height,
      width: width,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey[300],
          child: const Icon(Icons.error, color: Colors.red),
        );
      },
    );
  }
} 