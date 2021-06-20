import 'package:flutter/material.dart';
import 'dart:math';

class OrbitPainter extends CustomPainter {
  final Color color = Color(0xFF524F85);
  final double iconsSize = 24;
  final double radius;

  OrbitPainter({required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint p = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final Rect rect = Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2), radius: radius);

    // draw the three arcs
    canvas.drawArc(rect, -0.8 * pi, 1.8 * pi, false, p);

    //first shape
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
