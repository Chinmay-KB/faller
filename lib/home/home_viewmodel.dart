import 'dart:math';
import 'dart:ui';

import 'package:faller/utils/models/user.dart';
import 'package:faller/utils/widgets/orbit_widget.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'package:flutter/services.dart';

class HomeViewModel extends BaseViewModel {
  // bool _isOpen = false;
  late double _width;
  // late Path _path;
  late AnimationController _controller;
  late Animation _animation;
  late List<OrbitWidget> _orbits;
  late List<User> userData;

  double get width => _width;
  // bool get isOpen => _isOpen;
  double get animationValue => _animation.value;
  AnimationController get controller => _controller;
  List<OrbitWidget> get orbits => _orbits;

  toggleMenu(int index) {
    userData[index].toggleDialog();
    if (userData[index].isOpen)
      _controller.stop();
    else
      _controller.forward();
    notifyListeners();
  }

  init({required double width, required TickerProvider tickerProvider}) async {
    setBusy(true);
    _width = width;
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
    setBusy(false);
  }

  Offset calculate(double value, Path path, int index) {
    PathMetrics pathMetrics = path.computeMetrics();
    PathMetric pathMetric = pathMetrics.elementAt(0);
    pathMetric.extractPath(0.0 + (index + 1) / 2, pathMetric.length * value);
    value = pathMetric.length * value;
    Tangent? pos = pathMetric.getTangentForOffset(value);
    return pos!.position;
  }

  Path drawPath(double radius, int index) {
    Path path = Path();
    final Rect rect = Rect.fromCircle(
        center: Offset((_width - 40) / 2, (_width - 40) / 2), radius: radius);
    path.addOval(rect);
    return path;
  }

  initUserData() {
    userData = List.generate(
        3,
        (index) => User(
            path: drawPath(60, index),
            data: {'radius': (60).toString(), 'index': '$index'})).toList();
  }
}
