import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class LocationIconPainter extends CustomPainter {
  final Color primaryColor;
  final Color borderColor;
  final double direction;

  const LocationIconPainter({
    required this.primaryColor,
    required this.borderColor,
    required this.direction,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = size.width * 0.6;

    canvas.save();
    final Path clipPath = Path()
      ..addOval(Rect.fromCircle(center: center, radius: radius));
    canvas.clipPath(clipPath);
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(direction);
    canvas.translate(-center.dx, -center.dy);

    // Draw direction cone with adjusted dimensions
    final ui.Path conePath = Path();
    final double coneWidth = size.width;
    final double coneHeight = size.height * 0.8;
    final double coneYOffset = size.height * 0.20;

    conePath.moveTo(center.dx, center.dy - coneHeight / 2 + coneYOffset);
    conePath.lineTo(
        center.dx + coneWidth / 2, center.dy + coneHeight / 2 + coneYOffset);
    conePath.lineTo(
        center.dx - coneWidth / 2, center.dy + coneHeight / 2 + coneYOffset);
    conePath.close();

    // Create gradient for the cone
    final ui.Gradient coneGradient = ui.Gradient.radial(
      Offset(center.dx, center.dy - coneHeight / 2 + coneYOffset),
      radius * 1.25,
      <ui.Color>[
        primaryColor,
        primaryColor.withValues(alpha: 0.0),
      ],
    );

    final ui.Paint conePaint = Paint()..shader = coneGradient;
    canvas.drawPath(conePath, conePaint);

    // Restore canvas rotation
    canvas.restore();

    // Draw the outer white circle shadow
    final ui.Paint shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, size.width * 0.20, shadowPaint);

    // Draw outer white circle for border
    final double outerCircleRadius = size.width * 0.20;
    final ui.Paint outerCirclePaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, outerCircleRadius, outerCirclePaint);

    // Draw inner colored circle
    final double innerCircleRadius = size.width * 0.13;
    final ui.Paint innerCirclePaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, innerCircleRadius, innerCirclePaint);

    // Restore the original canvas state
    canvas.restore();
  }

  @override
  bool shouldRepaint(LocationIconPainter oldDelegate) {
    return oldDelegate.primaryColor != primaryColor ||
        oldDelegate.borderColor != borderColor ||
        oldDelegate.direction != direction;
  }
}

class UserLocationIcon extends StatelessWidget {
  final double size;
  final Color primaryColor;
  final Color borderColor;
  final double direction;

  const UserLocationIcon({
    super.key,
    this.size = 64.0,
    this.primaryColor = Colors.grey,
    this.borderColor = Colors.white,
    this.direction = pi,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: LocationIconPainter(
          primaryColor: primaryColor,
          borderColor: borderColor,
          direction: direction,
        ),
      ),
    );
  }
}
