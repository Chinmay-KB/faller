import 'dart:math';
import 'dart:ui';

import 'package:faller/utils/models/orbit.dart';
import 'package:faller/utils/models/user.dart';
import 'package:faller/utils/widgets/orbit_widget.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'package:flutter/services.dart';

class HomeViewModel extends BaseViewModel {
  // bool _isOpen = false;
  late double _width;
  late double _height;
  // late Path _path;
  late AnimationController _controller;
  late Animation _animation;
  late List<Orbit> _orbits;
  late List<User> userData;

  double get width => _width;
  double get height => _height;
  // bool get isOpen => _isOpen;
  double get animationValue => _animation.value;
  AnimationController get controller => _controller;
  List<Orbit> get orbits => _orbits;

  toggleMenu(int index) {
    userData[index].toggleDialog();
    if (userData[index].isOpen)
      _controller.stop();
    else
      _controller.forward();
    notifyListeners();
  }

  init(
      {required double width,
      required double height,
      required TickerProvider tickerProvider}) async {
    setBusy(true);
    _width = width;
    _height = height;
    // _path = drawPath(60);
    _controller = AnimationController(
        vsync: tickerProvider, duration: Duration(milliseconds: 5000));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        if (_controller.isCompleted) _controller.repeat();
        notifyListeners();
      });
    _controller.forward();
    initUserData();
    initOrbitData();
    setBusy(false);
  }

  Offset calculate(double value, Path path, double seed) {
    PathMetrics pathMetrics = path.computeMetrics();
    PathMetric pathMetric = pathMetrics.elementAt(0);
    value = value + seed;
    if (value > 1) value = value - 1;
    value = pathMetric.length * value;
    Tangent? pos = pathMetric.getTangentForOffset(value);
    return pos!.position;
  }

  Path drawPath(double radius) {
    Path path = Path();
    final Rect rect = Rect.fromCircle(
        center: Offset((_width - 40) / 2, (_width - 40) / 2), radius: radius);
    path.addOval(rect);
    return path;
  }

  initUserData() {
    userData = List.generate(
      4,
      (index) => User(
        path: drawPath(180),
        data: {
          'radius': (180).toString(),
          'index': '$index',
          'seed': '${Random().nextDouble() * 0.99}'
        },
      ),
    ).toList();
  }

  initOrbitData() {
    _orbits = List.generate(
        3,
        (index) => Orbit(radius: 60 * (index + 1), data: {
              'level': '$index',
              'seed': '${Random().nextDouble() * 0.99}'
            }));
  }
}
