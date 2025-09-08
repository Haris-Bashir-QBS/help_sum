import 'dart:math';
import 'package:flutter/material.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';

class CustomDotsLoader extends StatefulWidget {
  final double size;
  final Duration duration;
  final Color dot1Color;
  final Color dot2Color;
  final double strokeWidth;

  const CustomDotsLoader({
    super.key,
    this.size = 50,
    this.duration = const Duration(seconds: 2),
    this.dot1Color = AppPalette.starColor,
    this.dot2Color = AppPalette.infoColor,
    this.strokeWidth = 3,
  });

  @override
  State<CustomDotsLoader> createState() => _CustomDotsLoaderState();
}

class _CustomDotsLoaderState extends State<CustomDotsLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          return CustomPaint(
            painter: _LoaderPainter(
              progress: _controller.value,
              dot1Color: widget.dot1Color,
              dot2Color: widget.dot2Color,
              strokeWidth: widget.strokeWidth,
            ),
          );
        },
      ),
    );
  }
}

class _LoaderPainter extends CustomPainter {
  final double progress;
  final Color dot1Color;
  final Color dot2Color;
  final double strokeWidth;

  _LoaderPainter({
    required this.progress,
    required this.dot1Color,
    required this.dot2Color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide / 2) - strokeWidth;

    // Draw ring
    final ringPaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..color = AppPalette.primaryColor;
    canvas.drawCircle(center, radius, ringPaint);

    // Dots
    final double dotRadius = strokeWidth * 1.3;
    final angle1 = 2 * pi * progress;
    final angle2 = angle1 + pi;

    final pos1 = Offset(
      center.dx + radius * cos(angle1),
      center.dy + radius * sin(angle1),
    );

    final pos2 = Offset(
      center.dx + radius * cos(angle2),
      center.dy + radius * sin(angle2),
    );

    canvas.drawCircle(pos1, dotRadius, Paint()..color = dot1Color);
    canvas.drawCircle(pos2, dotRadius, Paint()..color = dot2Color);
  }

  @override
  bool shouldRepaint(covariant _LoaderPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.dot1Color != dot1Color ||
      oldDelegate.dot2Color != dot2Color;
}
