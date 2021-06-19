import 'package:faller/utils/animations/orbit_painter.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class OrbitWidget extends StatelessWidget {
  const OrbitWidget({required this.animationValue, required this.radius});

  final double animationValue;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 2 * pi * animationValue,
      child: CustomPaint(painter: OrbitPainter(radius: radius)),
    );
  }
}
