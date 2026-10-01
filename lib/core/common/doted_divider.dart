import 'package:flutter/material.dart';
import 'package:flutter_project_structure/core/utils/app_colors.dart';

class DottedDivider extends StatelessWidget {
  final double thickness;
  final double? height;
  final double? width;
  final Color? color;
  final double dashWidth;
  final double dashSpace;
  final Axis axis;
  final StrokeCap strokeCap;
  final double indent;
  final double endIndent;
  final EdgeInsetsGeometry? margin;

  const DottedDivider({
    super.key,
    this.thickness = 1.0,
    this.height,
    this.width,
    this.color,
    this.dashWidth = 5.0,
    this.dashSpace = 4.0,
    this.axis = Axis.horizontal,
    this.strokeCap = StrokeCap.round,
    this.indent = 0.0,
    this.endIndent = 0.0,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppColors.dividerColor;
    final isHorizontal = axis == Axis.horizontal;

    Widget divider = SizedBox(
      width: isHorizontal ? (width ?? double.infinity) : (width ?? thickness),
      height: isHorizontal
          ? (height ?? thickness)
          : (height ?? double.infinity),
      child: CustomPaint(
        painter: _DottedLinePainter(
          color: effectiveColor,
          dashLength: dashWidth,
          dashSpace: dashSpace,
          strokeWidth: thickness,
          strokeCap: strokeCap,
          axis: axis,
          indent: indent,
          endIndent: endIndent,
        ),
      ),
    );

    if (margin != null) {
      divider = Padding(padding: margin!, child: divider);
    }

    return divider;
  }
}

class _DottedLinePainter extends CustomPainter {
  final Color color;
  final double dashLength;
  final double dashSpace;
  final double strokeWidth;
  final StrokeCap strokeCap;
  final Axis axis;
  final double indent;
  final double endIndent;

  _DottedLinePainter({
    required this.color,
    required this.dashLength,
    required this.dashSpace,
    required this.strokeWidth,
    required this.strokeCap,
    required this.axis,
    required this.indent,
    required this.endIndent,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (!size.width.isFinite || !size.height.isFinite) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = strokeCap
      ..style = PaintingStyle.stroke;

    if (axis == Axis.horizontal) {
      final double y = size.height / 2;
      double startX = indent;
      final double maxExtent = size.width - endIndent;

      if (maxExtent <= startX) return;

      while (startX < maxExtent) {
        final double endX = (startX + dashLength).clamp(startX, maxExtent);
        canvas.drawLine(Offset(startX, y), Offset(endX, y), paint);
        startX += dashLength + dashSpace;
      }
    } else {
      final double x = size.width / 2;
      double startY = indent;
      final double maxExtent = size.height - endIndent;

      if (maxExtent <= startY) return;

      while (startY < maxExtent) {
        final double endY = (startY + dashLength).clamp(startY, maxExtent);
        canvas.drawLine(Offset(x, startY), Offset(x, endY), paint);
        startY += dashLength + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DottedLinePainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.dashLength != dashLength ||
        oldDelegate.dashSpace != dashSpace ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.strokeCap != strokeCap ||
        oldDelegate.axis != axis ||
        oldDelegate.indent != indent ||
        oldDelegate.endIndent != endIndent;
  }
}
