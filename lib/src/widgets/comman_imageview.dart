import 'dart:io';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomImageView extends StatelessWidget {
  final String? imagePath;
  final File? file;
  final ImageType imageType;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? errorWidget;
  final Border? border;
  final bool isCircle;

  const CustomImageView({
    super.key,
    this.imagePath,
    this.file,
    required this.imageType,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.errorWidget,
    this.border,
    this.isCircle = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    switch (imageType) {
      case ImageType.network:
        imageWidget = ExtendedImage.network(
          imagePath ?? '',
          width: width,
          height: height,
          fit: fit,
          cache: true,
          borderRadius: borderRadius,
          border: border,
          // shape: borderRadius != null ? BoxShape.rectangle : BoxShape.rectangle,
          loadStateChanged: (state) {
            switch (state.extendedImageLoadState) {
              case LoadState.loading:
                return _buildShimmer(width, height, borderRadius);
              case LoadState.failed:
                return errorWidget ??
                    _buildErrorWidget(width, height, borderRadius);
              case LoadState.completed:
                return ExtendedRawImage(
                  image: state.extendedImageInfo?.image,
                  width: width,
                  height: height,
                  fit: fit,
                );
            }
          },
        );
        break;
      case ImageType.asset:
        imageWidget = ExtendedImage.asset(
          imagePath ?? '',
          width: width,
          height: height,
          fit: fit,
          loadStateChanged: (state) {
            switch (state.extendedImageLoadState) {
              case LoadState.loading:
                return _buildShimmer(width, height, borderRadius);
              case LoadState.failed:
                return errorWidget ??
                    _buildErrorWidget(width, height, borderRadius);
              case LoadState.completed:
                return ExtendedRawImage(
                  image: state.extendedImageInfo?.image,
                  width: width,
                  height: height,
                  fit: fit,
                );
            }
          },
        );
        if (!isCircle) {
          imageWidget = ClipRRect(
            borderRadius: borderRadius ?? BorderRadius.zero,
            child: imageWidget,
          );
        }
        break;
      case ImageType.file:
        imageWidget =
            file != null
                ? ExtendedImage.file(
                  file!,
                  width: width,
                  height: height,
                  fit: fit,
                  loadStateChanged: (state) {
                    switch (state.extendedImageLoadState) {
                      case LoadState.loading:
                        return _buildShimmer(width, height, borderRadius);
                      case LoadState.failed:
                        return errorWidget ??
                            _buildErrorWidget(width, height, borderRadius);
                      case LoadState.completed:
                        return ExtendedRawImage(
                          image: state.extendedImageInfo?.image,
                          width: width,
                          height: height,
                          fit: fit,
                        );
                    }
                  },
                )
                : errorWidget ?? _buildErrorWidget(width, height, borderRadius);
        if (!isCircle) {
          imageWidget = ClipRRect(
            borderRadius: borderRadius ?? BorderRadius.zero,
            child: imageWidget,
          );
        }
        break;
    }

    if (isCircle) {
      imageWidget = ClipOval(child: imageWidget);
    }

    return imageWidget;
  }

  Widget _buildShimmer(
    double? width,
    double? height,
    BorderRadius? borderRadius,
  ) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.zero,
        color: Colors.grey.shade300,
      ),
      child: Center(
        child: SizedBox(
          width: 32,
          height: 32,
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: const Icon(Icons.image, color: Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(
    double? width,
    double? height,
    BorderRadius? borderRadius,
  ) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.zero,
        color: Colors.grey.shade200,
      ),
      child: const Icon(Icons.broken_image, color: Colors.grey),
    );
  }
}

enum ImageType { network, asset, file }
