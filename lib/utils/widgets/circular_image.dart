import 'package:flutter/material.dart';

class CircularImage extends StatelessWidget {
  final double radius;
  final ImageProvider image;

  const CircularImage(this.radius, this.image);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: radius,
      width: radius,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(image: image, fit: BoxFit.cover)),
    );
  }
}
