import 'package:flutter/material.dart';

class Orbit {
  final double _radius;
  final Widget widget;

  Orbit({required double radius, required this.widget}) : _radius = radius;

  double get radius => _radius;
}
