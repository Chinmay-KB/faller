import 'dart:math';

import 'package:faller/utils/colors.dart';
import 'package:flutter/material.dart';

/// Dots shown in the background
class PolkaDot extends StatefulWidget {
  /// Constructor for [PolkaDot]
  const PolkaDot({
    Key? key,
    required Alignment alignment,
    required double radius,
    required int colorChoice,
  })  : _alignment = alignment,
        _colorChoice = colorChoice,
        _radius = radius,
        super(key: key);

  final Alignment _alignment;
  final double _radius;
  final int _colorChoice;

  @override
  _PoltaDotState createState() => _PoltaDotState();
}

class _PoltaDotState extends State<PolkaDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;
  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: Duration(seconds: 1 + Random().nextInt(5)));
    _animationController.repeat(reverse: true);
    _animation = CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
        reverseCurve: Curves.easeOut)
      ..addListener(() {
        if (_animation.isCompleted) _animationController.reverse();
        if (_animation.isDismissed) _animationController.forward();

        setState(() {});
      });
    _animationController.forward();

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget._alignment,
      child: AnimatedOpacity(
        opacity: _animation.value,
        duration: const Duration(milliseconds: 1000),
        child: Container(
          height: widget._radius,
          width: widget._radius,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.transparent),
              color: AppColors.pastelColors[widget._colorChoice],
              borderRadius: const BorderRadius.all(Radius.circular(20))),
        ),
      ),
    );
  }
}
