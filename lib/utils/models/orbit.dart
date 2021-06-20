import 'package:flutter/material.dart';

class Orbit {
  final double _radius;
  final Map<String, String> _data;

  Orbit({required double radius, required Map<String, String> data})
      : _radius = radius,
        _data = data;

  double get radius => _radius;
  Map<String, String> get data => _data;
}
