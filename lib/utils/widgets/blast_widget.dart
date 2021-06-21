import 'package:faller/home/home_viewmodel.dart';
import 'package:flutter/material.dart';

class BlastWidget extends StatelessWidget {
  final HomeViewModel model;
  const BlastWidget({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: model.blastValue != 0 ? model.width : 0,
      height: model.blastValue != 0 ? model.height : 0,
      child: Center(
        child: AnimatedOpacity(
          opacity: model.blastValue * 0.99,
          duration: Duration(milliseconds: 2000),
          curve: Curves.easeOutExpo,
          child: Text(
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
          Color(0xffFFD369),
          Color.fromARGB((255 * model.blastValue).floor(), 255, 255, 255)
        ], radius: 10 * model.blastValue),
      ),
    );
  }
}
