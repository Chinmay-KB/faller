import 'package:faller/utils/animations/orbit_painter.dart';
import 'package:flutter/material.dart';
import 'dart:math';

/// Widget made using [Transform.rotate()] and [OrbitPainter()] for showing an
/// orbit in rotation
class OrbitWidget extends StatelessWidget {
  /// constructor for OrbitWidget
  // ignore: use_key_in_widget_constructors
  const OrbitWidget(
      {required double animationValue,
      required double radius,
      required double seed})
      : _animationValue = animationValue,
        _radius = radius,
        _seed = seed;

  final double _animationValue;
  final double _radius;
  final double _seed;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 2 * pi * calculateAngle(),
      child: CustomPaint(painter: OrbitPainter(_radius)),
    );
  }

  /// Calculate angle of rotation. When [_animationValue] exceeds 1, it cycles the
  /// value back to `0.0`.
  double calculateAngle() {
    var value = _animationValue + _seed;
    if (value > 1) value = value - 1;
    return value;
  }
}
