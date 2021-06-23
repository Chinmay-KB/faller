import 'package:flutter/material.dart';

class MessageBorder extends ShapeBorder {
  final bool usePadding;
  final double dx;
  final double width;
  final String index;

  MessageBorder(this.dx, this.width, this.index, {this.usePadding = true});

  @override
  EdgeInsetsGeometry get dimensions =>
      EdgeInsets.only(bottom: usePadding ? 20 : 0);

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
