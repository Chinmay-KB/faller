import 'package:flutter/material.dart';

/// Widget for circular image shown in planets
class CircularImage extends StatelessWidget {
  final double _radius;
  final ImageProvider _image;

  /// Contstructor for [CircularImage]
  const CircularImage(
    this._radius,
    this._image, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _radius,
      width: _radius,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(image: _image, fit: BoxFit.cover),
          boxShadow: [
            const BoxShadow(
                color: Colors.grey, offset: Offset(0, 1), blurRadius: 12)
          ]),
    );
  }
}
