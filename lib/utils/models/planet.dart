import 'package:flutter/material.dart';

/// PODO for User
class Planet {
  bool _isOpen = false;
  final double _radius;
  final Map<String?, String?> _data;
  final ImageProvider _image;

  /// Constructor for [Planet]
  Planet(
      {required Map<String?, String?> data,
      required double radius,
      required ImageProvider image})
      : _radius = radius,
        _data = data,
        _image = image;

  /// Toggles whether info dialog is open for the planet or not
  toggleDialog() => _isOpen = !_isOpen;

  /// Get radius of the planet
  double get radius => _radius;

  /// Get data payload associated with the planet
  Map<String?, String?> get data => _data;

  /// Get image to be shown in the planet
  ImageProvider get image => _image;

  /// Get whether info dialog for the planet is open or not. `false` by default.
  bool get isOpen => _isOpen;
}
