import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

class TimelinePainter extends CustomPainter {
  final Color lineColor;
  final Color dotColor;
  final double lineWidth;
  final double dotRadius;

  TimelinePainter({
    required this.lineColor,
    required this.dotColor,
    this.lineWidth = 2.0,
    this.dotRadius = 11.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Defines the appearance of the line (color and thickness)
    final linePaint =
        Paint()
          ..color = lineColor
          ..strokeWidth = lineWidth;

    // Defines the appearance of the dots (color and fill style)
    final dotPaint =
        Paint()
          ..color = dotColor
          ..style = PaintingStyle.fill;

    // Calculate the horizontal center for drawing
    final double centerX = size.width / 2;

    // Calculate the vertical positions for the dots' centers.
    // They are positioned relative to the top and bottom of the canvas.
    final Offset topDotCenter = Offset(centerX, dotRadius);
    final Offset bottomDotCenter = Offset(centerX, size.height - dotRadius);

    // Draw the vertical line connecting the centers of the two dots
    canvas.drawLine(topDotCenter, bottomDotCenter, linePaint);

    // Draw the top and bottom dots at their calculated positions
    canvas.drawCircle(topDotCenter, dotRadius, dotPaint);
    canvas.drawCircle(bottomDotCenter, dotRadius, dotPaint);
  }

  @override
  bool shouldRepaint(covariant TimelinePainter oldDelegate) {
    // The painter should only redraw if its properties have changed.
    return oldDelegate.lineColor != lineColor ||
        oldDelegate.dotColor != dotColor ||
        oldDelegate.lineWidth != lineWidth ||
        oldDelegate.dotRadius != dotRadius;
  }
}

class LocationTimeline extends StatelessWidget {
  const LocationTimeline({super.key});

  @override
  Widget build(BuildContext context) {
    const double dotRadius = 5.0;
    const double dotDiameter = dotRadius * 3;

    // IntrinsicHeight is crucial for making the painter's canvas the same
    // height as the column of text content.
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // This SizedBox provides a dedicated area for our CustomPaint widget.
          SizedBox(
            width: 40,
            child: CustomPaint(
              // The painter property takes an instance of our TimelinePainter.
              painter: TimelinePainter(
                lineColor: Color(0xFF5C5C5C),
                dotColor: Color(0xFF04DB00),
                dotRadius: dotRadius,
              ),
            ),
          ),
          // The layout of this Column determines the overall height of the widget.
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextContainer(
                  'Scheme 1 Road, Chaklala Cantt.',
                  height: dotDiameter,
                ),
                // This SizedBox creates the space between the two timeline points.
                // Its height directly controls the length of the connector line.
                const SizedBox(height: 20),
                _buildTextContainer(
                  'House no 4783, lane 5 - lalazar - Rawalpindi',
                  height: dotDiameter,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Helper to build a text container with a specific height, ensuring it
  /// aligns vertically with the dots drawn by the painter.
  Widget _buildTextContainer(String text, {required double height}) {
    return Container(
      height: height,
      alignment: Alignment.centerLeft,
      child: CustomText(
        text: text,
        fontSize: 11,
        // style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
      ),
    );
  }
}
