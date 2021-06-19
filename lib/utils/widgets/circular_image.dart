import 'package:flutter/material.dart';

class CircularImage extends StatelessWidget {
  final double radius;

  const CircularImage(this.radius);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: radius,
      width: radius,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
              image: AssetImage('assets/bean.png'), fit: BoxFit.contain)),
    );
  }
}
