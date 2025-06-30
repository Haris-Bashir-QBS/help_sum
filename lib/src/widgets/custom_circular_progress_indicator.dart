import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/extensions/context_extensions.dart';

class CustomCircularProgressIndicator extends StatelessWidget {
  final Color? color;
  final double size;

  const CustomCircularProgressIndicator({
    super.key,
    this.color,
    this.size = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitFadingCircle(
        color: color ?? AppPalette.primaryColor,
        size: size,
      ),
    );
  }
}
