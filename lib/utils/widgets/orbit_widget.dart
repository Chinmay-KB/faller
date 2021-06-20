import 'package:faller/utils/animations/orbit_painter.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class OrbitWidget extends StatelessWidget {
  const OrbitWidget(
      {required this.animationValue, required this.radius, required this.seed});

  final double animationValue;
  final double radius;
  final double seed;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 2 * pi * calculateAngle(),
      child: CustomPaint(painter: OrbitPainter(radius: radius)),
    );
  }

  double calculateAngle() {
    var value = animationValue + seed;
    if (value > 1) value = value - 1;

    print('seed is $seed value is $value');

    return value;
  }
}
