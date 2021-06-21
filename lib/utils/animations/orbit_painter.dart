import 'package:flutter/material.dart';
import 'dart:math';

/// CustomPainter for painting orbits of the planets
class OrbitPainter extends CustomPainter {
  final _color = const Color(0xFF524F85);
  final double _radius;

  /// Constructor for OrbitPainter
  OrbitPainter(double radius) : _radius = radius;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint p = Paint()
      ..color = _color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final Rect rect = Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2), radius: _radius);

    // draw the three arcs
    canvas.drawArc(rect, -0.8 * pi, 1.8 * pi, false, p);

    //first shape
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
