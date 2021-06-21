import 'dart:math';

import 'package:faller/utils/colors.dart';
import 'package:flutter/material.dart';

class PolkaDot extends StatefulWidget {
  const PolkaDot({
    Key? key,
    required this.alignment,
    required this.radius,
    required this.colorChoice,
  }) : super(key: key);

  final Alignment alignment;
  final double radius;
  final int colorChoice;

  @override
  _PoltaDotState createState() => _PoltaDotState();
}

class _PoltaDotState extends State<PolkaDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;
  @override
  void initState() {
    _animationController = new AnimationController(
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
      alignment: widget.alignment,
      child: AnimatedOpacity(
        opacity: _animation.value,
        duration: Duration(milliseconds: 1000),
        child: Container(
          height: widget.radius,
          width: widget.radius,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.transparent),
              color: AppColors.PASTEL_COLORS[widget.colorChoice],
              borderRadius: BorderRadius.all(Radius.circular(20))),
        ),
      ),
    );
  }
}
