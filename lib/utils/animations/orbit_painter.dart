import 'package:flutter/material.dart';
import 'dart:math';

class OrbitPainter extends CustomPainter {
  final Color color = Colors.black;
  final double iconsSize = 24;
  final double radius;

  OrbitPainter({required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint p = Paint()
      ..color = color
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final Rect rect = Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2), radius: radius);

    // draw the three arcs
    canvas.drawArc(rect, 0 * pi, 1.67 * pi, false, p);

    //first shape
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
