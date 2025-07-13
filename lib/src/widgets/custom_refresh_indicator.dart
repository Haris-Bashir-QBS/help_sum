import 'package:flutter/material.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';

class CustomRefreshIndicator extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  final Color? color;
  final Color? backgroundColor;

  const CustomRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
    this.color,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: color ?? AppPalette.primaryColor,
      backgroundColor: backgroundColor ?? AppPalette.whiteColor,
      strokeWidth: 3.0,
      child: child,
    );
  }
}
