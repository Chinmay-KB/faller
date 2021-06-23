import 'package:flutter/material.dart';

/// Custom [ShapeBorder] implementaiton to show the arrow coming out of the info
/// box pointing towards the planet.
class InfoDialogBorder extends ShapeBorder {
  /// Position of the parent planet absolute to the screen.
  final double dx;

  /// Width of screen
  final double width;

  /// Index of planet, to check if it is the sun or not
  final String index;

  /// Constructor for [InfoDialogBorder].
  const InfoDialogBorder(this.dx, this.width, this.index);

  @override
  EdgeInsetsGeometry get dimensions => const EdgeInsets.only(bottom: 20);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => Path();

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    // Dialog in center
    if (index == '-1') {
      return Path()
        ..moveTo(rect.bottomCenter.dx - 20, rect.bottomCenter.dy - 20)
        ..relativeLineTo(20, 20)
        ..relativeLineTo(20, -20)
        ..close();
    }
    // Dialog to right
    if (dx < width / 2) {
      return Path()
        ..moveTo(rect.bottomLeft.dx, rect.bottomLeft.dy - 25)
        ..relativeLineTo(0, 30)
        ..relativeLineTo(30, -30)
        ..close();
    }
    // Dialog to left
    else {
      return Path()
        ..moveTo(rect.bottomRight.dx - 30, rect.bottomRight.dy - 25)
        ..relativeLineTo(30, 30)
        ..relativeLineTo(0, -30)
        ..close();
    }
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;
}
