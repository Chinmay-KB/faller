import 'package:faller/home/home_viewmodel.dart';
import 'package:faller/utils/colors.dart';
import 'package:flutter/material.dart';

/// Widget showing blast of big bang
class BlastWidget extends StatelessWidget {
  final HomeViewModel _model;

  /// Constructor for [BlastWidget]
  const BlastWidget({Key? key, required HomeViewModel model})
      : _model = model,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _model.blastValue != 0 ? _model.width : 0,
      height: _model.blastValue != 0 ? _model.height : 0,
      child: Center(
        child: AnimatedOpacity(
          opacity: _model.blastValue * 0.99,
          duration: const Duration(milliseconds: 2000),
          curve: Curves.easeOutExpo,
          child: const Text(
            'Lorem Ipsum',
            style: TextStyle(
                color: Colors.deepOrangeAccent,
                fontSize: 36,
                fontWeight: FontWeight.w700),
          ),
        ),
      ),
      decoration: BoxDecoration(
        gradient: RadialGradient(colors: [
          AppColors.blastColor,
          Color.fromARGB((255 * _model.blastValue).floor(), 255, 255, 255)
        ], radius: 10 * _model.blastValue),
      ),
    );
  }
}
