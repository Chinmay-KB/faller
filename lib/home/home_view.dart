import 'dart:ui';

import 'package:faller/home/home_viewmodel.dart';
import 'package:faller/utils/animations/orbit_painter.dart';
import 'package:faller/utils/widgets/circular_image.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'dart:math';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;
  late Path _path;
  late double _width;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 5000));
    super.initState();
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {
          if (_controller.isCompleted) _controller.repeat();
        });
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Path drawPath(double radius) {
    Path path = Path();
    final Rect rect = Rect.fromCircle(
        center: Offset((_width - radius / 2) / 2, (_width - radius / 2) / 2),
        radius: radius);
    path.addOval(rect);
    return path;
  }

  Offset calculate(value) {
    PathMetrics pathMetrics = _path.computeMetrics();
    PathMetric pathMetric = pathMetrics.elementAt(0);
    value = pathMetric.length * value;
    Tangent? pos = pathMetric.getTangentForOffset(value);
    return pos!.position;
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      onModelReady: (model) {
        _width = MediaQuery.of(context).size.width;
        _path = drawPath(100);

        model.init();
      },
      builder: (
        BuildContext context,
        HomeViewModel model,
        Widget? child,
      ) {
        return Scaffold(
            body: model.isBusy
                ? Center(child: CircularProgressIndicator())
                : Center(
                    child: Container(
                    height: MediaQuery.of(context).size.width,
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Transform.rotate(
                          angle: 2 * pi * _animation.value,
                          child: CustomPaint(
                            painter: OrbitPainter(radius: 100),
                          ),
                        ),
                        Positioned(
                          child: CircularImage(40),
                          top: calculate(_animation.value).dy,
                          left: calculate(_animation.value).dx,
                        )
                      ],
                    ),
                  )));
      },
    );
  }
}
