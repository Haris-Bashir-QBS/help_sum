

import 'dart:math';
import 'package:flutter/material.dart';


class BubbleClipper extends CustomClipper<Path> {
  BubbleClipper({
    required this.radius,
    required this.showNip,
    required this.nip,
    required this.nipWidth,
    required this.nipHeight,
    required this.nipOffset,
    required this.nipRadius,
    required this.stick,
    required this.padding,
  })   : assert(nipWidth > 0),
        assert(nipHeight > 0),
        assert(nipRadius >= 0),
        assert(nipRadius <= nipWidth / 2 && nipRadius <= nipHeight / 2),
        super() {
    if (nip == BubbleNip.no) return;

    _startOffset = _endOffset = nipWidth;

    final isCenter =
        nip == BubbleNip.leftCenter || nip == BubbleNip.rightCenter;
    final k = isCenter ? nipHeight / 2 / nipWidth : nipHeight / nipWidth;
    final a = atan(k);

    _nipCX = isCenter
        ? sqrt(nipRadius * nipRadius * (1 + 1 / k / k))
        : (nipRadius + sqrt(nipRadius * nipRadius * (1 + k * k))) / k;
    final nipStickOffset = (_nipCX - nipRadius).floorToDouble();

    _nipCX -= nipStickOffset;
    _nipCY = isCenter ? 0 : nipRadius;
    _nipPX = _nipCX - nipRadius * sin(a);
    _nipPY = _nipCY + nipRadius * cos(a);
    _startOffset -= nipStickOffset;
    _endOffset -= nipStickOffset;

    if (stick) _endOffset = 0;
  }

  final Radius radius;
  final bool showNip;
  final BubbleNip nip;
  final double nipHeight;
  final double nipWidth;
  final double nipOffset;
  final double nipRadius;
  final bool stick;
  final EdgeInsets padding;

  double _startOffset = 0; // Offsets of the bubble
  double _endOffset = 0;
  double _nipCX = 0; // The center of the circle
  double _nipCY = 0;
  double _nipPX = 0; // The point of contact of the nip with the circle
  double _nipPY = 0;

  EdgeInsets get edgeInsets {
    switch (nip) {
      case BubbleNip.leftTop:
      case BubbleNip.leftBottom:
      case BubbleNip.leftCenter:
        return EdgeInsets.only(
            left: _startOffset + padding.left,
            top: padding.top,
            right: _endOffset + padding.right,
            bottom: padding.bottom);

      case BubbleNip.rightTop:
      case BubbleNip.rightBottom:
      case BubbleNip.rightCenter:
        return EdgeInsets.only(
            left: _endOffset + padding.left,
            top: padding.top,
            right: _startOffset + padding.right,
            bottom: padding.bottom);

      default:
        return EdgeInsets.only(
            left: _endOffset + padding.left,
            top: padding.top,
            right: _endOffset + padding.right,
            bottom: padding.bottom);
    }
  }

  @override
  Path getClip(Size size) {
    var radiusX = radius.x;
    var radiusY = radius.y;
    final maxRadiusX = size.width / 2;
    final maxRadiusY = size.height / 2;

    if (radiusX > maxRadiusX) {
      radiusY *= maxRadiusX / radiusX;
      radiusX = maxRadiusX;
    }
    if (radiusY > maxRadiusY) {
      radiusX *= maxRadiusY / radiusY;
      radiusY = maxRadiusY;
    }

    var path = Path();

    switch (nip) {
      case BubbleNip.leftTop:
      case BubbleNip.leftBottom:
      case BubbleNip.leftCenter:
        path.addRRect(RRect.fromLTRBR(
            _startOffset, 0, size.width - _endOffset, size.height, radius));
        break;

      case BubbleNip.rightTop:
      case BubbleNip.rightBottom:
      case BubbleNip.rightCenter:
        path.addRRect(RRect.fromLTRBR(
            _endOffset, 0, size.width - _startOffset, size.height, radius));
        break;

      default:
        path.addRRect(RRect.fromLTRBR(
            _endOffset, 0, size.width - _endOffset, size.height, radius));
    }

    if (showNip) {
      switch (nip) {
        case BubbleNip.leftTop:
          final path2 = Path()
            ..moveTo(_startOffset + radiusX, nipOffset)
            ..lineTo(_startOffset + radiusX, nipOffset + nipHeight)
            ..lineTo(_startOffset, nipOffset + nipHeight);

          if (nipRadius == 0) {
            path2.lineTo(0, nipOffset);
          } else {
            path2
              ..lineTo(_nipPX, nipOffset + _nipPY)
              ..arcToPoint(
                Offset(_nipCX, nipOffset),
                radius: Radius.circular(nipRadius),
              );
          }

          path2.close();
          path = Path.combine(PathOperation.union, path, path2);
          break;

        case BubbleNip.leftCenter:
          final cy = nipOffset + size.height / 2;
          final nipHalf = nipHeight / 2;

          final path2 = Path()
            ..moveTo(_startOffset, cy - nipHalf)
            ..lineTo(_startOffset + radiusX, cy - nipHalf)
            ..lineTo(_startOffset + radiusX, cy + nipHalf)
            ..lineTo(_startOffset, cy + nipHalf);

          if (nipRadius == 0) {
            path2.lineTo(0, cy);
          } else {
            path2
              ..lineTo(_nipPX, cy + _nipPY)
              ..arcToPoint(
                Offset(_nipPX, cy - _nipPY),
                radius: Radius.circular(nipRadius),
              );
          }

          path2.close();
          path = Path.combine(PathOperation.union, path, path2);
          break;

        case BubbleNip.leftBottom:
          final path2 = Path()
            ..moveTo(_startOffset + radiusX, size.height - nipOffset)
            ..lineTo(
                _startOffset + radiusX, size.height - nipOffset - nipHeight)
            ..lineTo(_startOffset, size.height - nipOffset - nipHeight);

          if (nipRadius == 0) {
            path2.lineTo(0, size.height - nipOffset);
          } else {
            path2
              ..lineTo(_nipPX, size.height - nipOffset - _nipPY)
              ..arcToPoint(
                Offset(_nipCX, size.height - nipOffset),
                radius: Radius.circular(nipRadius),
                clockwise: false,
              );
          }

          path2.close();
          path = Path.combine(PathOperation.union, path, path2);
          break;

        case BubbleNip.rightTop:
          final path2 = Path()
            ..moveTo(size.width - _startOffset - radiusX, nipOffset)
            ..lineTo(size.width - _startOffset - radiusX, nipOffset + nipHeight)
            ..lineTo(size.width - _startOffset, nipOffset + nipHeight);

          if (nipRadius == 0) {
            path2.lineTo(size.width, nipOffset);
          } else {
            path2
              ..lineTo(size.width - _nipPX, nipOffset + _nipPY)
              ..arcToPoint(
                Offset(size.width - _nipCX, nipOffset),
                radius: Radius.circular(nipRadius),
                clockwise: false,
              );
          }

          path2.close();
          path = Path.combine(PathOperation.union, path, path2);
          break;

        case BubbleNip.rightCenter:
          final cy = nipOffset + size.height / 2;
          final nipHalf = nipHeight / 2;

          final path2 = Path()
            ..moveTo(size.width - _startOffset, cy - nipHalf)
            ..lineTo(size.width - _startOffset - radiusX, cy - nipHalf)
            ..lineTo(size.width - _startOffset - radiusX, cy + nipHalf)
            ..lineTo(size.width - _startOffset, cy + nipHalf);

          if (nipRadius == 0) {
            path2.lineTo(size.width, cy);
          } else {
            path2
              ..lineTo(size.width - _nipPX, cy + _nipPY)
              ..arcToPoint(
                Offset(size.width - _nipPX, cy - _nipPY),
                radius: Radius.circular(nipRadius),
                clockwise: false,
              );
          }

          path2.close();
          path = Path.combine(PathOperation.union, path, path2);
          break;

        case BubbleNip.rightBottom:
          final path2 = Path()
            ..moveTo(
                size.width - _startOffset - radiusX, size.height - nipOffset)
            ..lineTo(size.width - _startOffset - radiusX,
                size.height - nipOffset - nipHeight)
            ..lineTo(
                size.width - _startOffset, size.height - nipOffset - nipHeight);

          if (nipRadius == 0) {
            path2.lineTo(size.width, size.height - nipOffset);
          } else {
            path2
              ..lineTo(size.width - _nipPX, size.height - nipOffset - _nipPY)
              ..arcToPoint(
                Offset(size.width - _nipCX, size.height - nipOffset),
                radius: Radius.circular(nipRadius),
              );
          }

          path2.close();
          path = Path.combine(PathOperation.union, path, path2);
          break;

        default:
      }
    }

    return path;
  }

  @override
  bool shouldReclip(BubbleClipper oldClipper) => false;
}




enum BubbleNip {
  no,
  leftTop,
  leftCenter,
  leftBottom,
  rightTop,
  rightCenter,
  rightBottom,
}

class Bubble extends StatelessWidget {
   Bubble({
    super.key,
    this.child,
    Radius? radius,
    bool? showNip,
    BubbleNip? nip,
    double? nipWidth,
    double? nipHeight,
    double? nipOffset,
    double? nipRadius,
    bool? stick,
    Color? color,
    Color? borderColor,
    double? borderWidth,
    bool? borderUp,
    double? elevation,
    Color? shadowColor,
    BubbleEdges? padding,
    BubbleEdges? margin,
    AlignmentGeometry? alignment,
    BubbleStyle? style,
  })  : color = color ?? style?.color ?? Colors.white,
        borderColor = borderColor ?? style?.borderColor ?? Colors.transparent,
        borderWidth = borderWidth ?? style?.borderWidth ?? 1,
        borderUp = borderUp ?? style?.borderUp ?? true,
        elevation = elevation ?? style?.elevation ?? 1,
        shadowColor = shadowColor ?? style?.shadowColor ?? Colors.black,
        margin = EdgeInsets.only(
          left: margin?.left ?? style?.margin?.left ?? 0,
          top: margin?.top ?? style?.margin?.top ?? 0,
          right: margin?.right ?? style?.margin?.right ?? 0,
          bottom: margin?.bottom ?? style?.margin?.bottom ?? 0,
        ),
        alignment = alignment ?? style?.alignment,
        bubbleClipper = BubbleClipper(
          radius: radius ?? style?.radius ?? const Radius.circular(6),
          showNip: showNip ?? style?.showNip ?? true,
          nip: nip ?? style?.nip ?? BubbleNip.no,
          nipWidth: nipWidth ?? style?.nipWidth ?? 8,
          nipHeight: nipHeight ?? style?.nipHeight ?? 10,
          nipOffset: nipOffset ?? style?.nipOffset ?? 0,
          nipRadius: nipRadius ?? style?.nipRadius ?? 1,
          stick: stick ?? style?.stick ?? false,
          padding: EdgeInsets.only(
            left: padding?.left ?? style?.padding?.left ?? 8,
            top: padding?.top ?? style?.padding?.top ?? 6,
            right: padding?.right ?? style?.padding?.right ?? 8,
            bottom: padding?.bottom ?? style?.padding?.bottom ?? 6,
          ),
        );

  final Widget? child;
  final Color color;
  final Color borderColor;
  final double borderWidth;
  final bool borderUp;
  final double elevation;
  final Color shadowColor;
  final EdgeInsets margin;
  final AlignmentGeometry? alignment;
  final BubbleClipper bubbleClipper;

  @override
  Widget build(BuildContext context) => Container(
        key: key,
        alignment: alignment,
        margin: margin,
        child: CustomPaint(
          painter: BubblePainter(
            clipper: bubbleClipper,
            color: color,
            borderColor: borderColor,
            borderWidth: borderWidth,
            borderUp: borderUp,
            elevation: elevation,
            shadowColor: shadowColor,
          ),
          child: Container(
            padding: bubbleClipper.edgeInsets,
            child: child,
          ),
        ),
      );
}



/// Class BubbleEdges is an analog of EdgeInsets, but default values are null.
class BubbleEdges {
  const BubbleEdges.fromLTRB(
    this.left,
    this.top,
    this.right,
    this.bottom,
  );

  const BubbleEdges.all(double? value)
      : left = value,
        top = value,
        right = value,
        bottom = value;

  const BubbleEdges.only({
    this.left,
    this.top,
    this.right,
    this.bottom,
  });

  const BubbleEdges.symmetric({
    double? vertical,
    double? horizontal,
  })  : left = horizontal,
        top = vertical,
        right = horizontal,
        bottom = vertical;

  final double? left;
  final double? top;
  final double? right;
  final double? bottom;

  EdgeInsets get edgeInsets =>
      EdgeInsets.fromLTRB(left ?? 0, top ?? 0, right ?? 0, bottom ?? 0);

  @override
  String toString() => 'BubbleEdges($left, $top, $right, $bottom)';
}


/// A painter for the Bubble.
class BubblePainter extends CustomPainter {
  BubblePainter({
    required this.clipper,
    required Color color,
    required Color borderColor,
    required double borderWidth,
    required this.borderUp,
    required this.elevation,
    required this.shadowColor,
  })   : _fillPaint = Paint()
          ..color = color
          ..style = PaintingStyle.fill,
        _strokePaint = borderWidth == 0 || borderColor == Colors.transparent
            ? null
            : (Paint()
              ..color = borderColor
              ..strokeWidth = borderWidth
              ..strokeCap = StrokeCap.round
              ..strokeJoin = StrokeJoin.round
              ..style = PaintingStyle.stroke);

  final CustomClipper<Path> clipper;
  final bool borderUp;
  final double elevation;
  final Color shadowColor;

  final Paint _fillPaint;
  final Paint? _strokePaint;

  @override
  void paint(Canvas canvas, Size size) {
    final clip = clipper.getClip(size);

    if (elevation != 0.0) {
      canvas.drawShadow(clip, shadowColor, elevation, false);
    }

    if (borderUp) canvas.drawPath(clip, _fillPaint);

    if (_strokePaint != null) {
      canvas.drawPath(clip, _strokePaint!);
    }

    if (!borderUp) canvas.drawPath(clip, _fillPaint);
  }

  @override
  bool shouldRepaint(covariant BubblePainter oldDelegate) => false;
}


/// A style for the Bubble.
class BubbleStyle {
  const BubbleStyle({
    this.radius,
    this.showNip,
    this.nip,
    this.nipWidth,
    this.nipHeight,
    this.nipOffset,
    this.nipRadius,
    this.stick,
    this.color,
    this.borderColor,
    this.borderWidth,
    this.borderUp,
    this.elevation,
    this.shadowColor,
    this.padding,
    this.margin,
    this.alignment,
  });

  final Radius? radius;
  final bool? showNip;
  final BubbleNip? nip;
  final double? nipHeight;
  final double? nipWidth;
  final double? nipOffset;
  final double? nipRadius;
  final bool? stick;
  final Color? color;
  final Color? borderColor;
  final double? borderWidth;
  final bool? borderUp;
  final double? elevation;
  final Color? shadowColor;
  final BubbleEdges? padding;
  final BubbleEdges? margin;
  final AlignmentGeometry? alignment;
}