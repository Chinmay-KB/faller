import 'dart:math';
import 'dart:ui';

import 'package:faller/utils/models/orbit.dart';
import 'package:faller/utils/models/user.dart';
import 'package:faller/utils/widgets/orbit_widget.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';

class HomeViewModel extends BaseViewModel {
  // bool _isOpen = false;
  late double _width;
  late double _height;
  // late Path _path;
  late AnimationController _controller,
      _radiusAnimationController,
      _blastGlowAnimationController;
  late Animation _animation, _radiusAnimation, _blastGlowAnimation;
  late List<Orbit> _orbits;
  late List<User> userData;
  bool isInfoOpen = false;
  User sun = User(
    radius: 0,
    image: AssetImage('assets/michaelscott.jpg'),
    data: {
      'index': '-1',
      'name': 'Michael Scott',
      'info': 'Regional Manager',
      'rating': '${Random().nextInt(6)}'
    },
  );

  double get width => _width;
  double get height => _height;
  double get animationValue => _animation.value;
  double get radiusValue => _radiusAnimation.value;
  double get blastValue => _blastGlowAnimation.value;

  AnimationController get controller => _controller;
  List<Orbit> get orbits => _orbits;

  toggleMenu(int index) {
    if (isInfoOpen == false) {
      userData[index].toggleDialog();
      if (userData[index].isOpen) {
        _controller.stop();
        isInfoOpen = true;
      }
      notifyListeners();
      Future.delayed(Duration(milliseconds: 3000), () async {
        userData[index].toggleDialog();
        _controller.forward();
        isInfoOpen = false;
      });
    }
  }

  toggleSun() {
    if (isInfoOpen == false) {
      sun.toggleDialog();
      if (sun.isOpen) {
        _controller.stop();
        isInfoOpen = true;
      }
      notifyListeners();
      Future.delayed(Duration(milliseconds: 3000), () async {
        sun.toggleDialog();
        _controller.forward();
        isInfoOpen = false;
      });
    }
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
        vsync: tickerProvider, duration: Duration(milliseconds: 10000));
    _animation = Tween(begin: 0.01, end: 1.0).animate(_controller)
      ..addListener(() {
        if (_controller.isCompleted) _controller.repeat();
        notifyListeners();
      });
    _controller.forward();
    _radiusAnimationController = AnimationController(
        value: 1,
        upperBound: 1,
        lowerBound: 0.1,
        vsync: tickerProvider,
        duration: Duration(milliseconds: 3000));
    _radiusAnimation = CurvedAnimation(
        parent: _radiusAnimationController,
        curve: Curves.easeIn,
        reverseCurve: Curves.easeInQuint);
    // Only for testing purposes
    // ..addListener(() {
    //   if (_radiusAnimation.isDismissed) _radiusAnimationController.forward();
    //   notifyListeners();
    // });
    _blastGlowAnimationController = AnimationController(
        vsync: tickerProvider, duration: Duration(milliseconds: 2000));
    _blastGlowAnimation = CurvedAnimation(
        parent: _blastGlowAnimationController, curve: Curves.easeInQuint);
    // Only for testing purposes
    // ..addListener(() {
    //   if (_blastGlowAnimation.isCompleted)
    //     _blastGlowAnimationController.reverse();
    // });
    initUserData();
    initOrbitData();
    setBusy(false);
  }

  startBang() async {
    _radiusAnimationController.reverse();
    _blastGlowAnimationController.forward();
    if ((await Vibration.hasAmplitudeControl())!) {
      print('Entering');
      Vibration.vibrate(
          duration: 2000,
          amplitude: (_blastGlowAnimationController.value * 255).toInt());
    } else
      Vibration.vibrate(duration: 2000);
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
        center: Offset((_width - 40) / 2, (height - 40) / 2), radius: radius);
    path.addOval(rect);
    return path;
  }

  initUserData() {
    userData = [
      User(
        radius: 60,
        image: AssetImage('assets/dwight.jpg'),
        data: {
          'radius': (60).toString(),
          'index': '0',
          'seed': '0.3',
          'name': 'Dwight',
          'info': 'Assistant to Regional Manager',
          'rating': '${Random().nextInt(6)}'
        },
      ),
      User(
        radius: 120,
        image: AssetImage('assets/jim.jpg'),
        data: {
          'radius': (120).toString(),
          'index': '1',
          'seed': '0.4',
          'name': 'Jim',
          'info': 'Salesman',
          'rating': '${Random().nextInt(6)}'
        },
      ),
      User(
        radius: 180,
        image: AssetImage('assets/pam.jpg'),
        data: {
          'radius': (180).toString(),
          'index': '2',
          'seed': '0.8',
          'name': 'Pam',
          'info': 'Receptionist',
          'rating': '${Random().nextInt(6)}'
        },
      ),
      User(
        radius: 180,
        image: AssetImage('assets/ryan.jpg'),
        data: {
          'radius': (180).toString(),
          'index': '3',
          'seed': '0.6',
          'name': 'Ryan',
          'info': 'Temp',
          'rating': '${Random().nextInt(6)}'
        },
      ),
      User(
        radius: 180,
        image: AssetImage('assets/creed.jpg'),
        data: {
          'radius': (180).toString(),
          'index': '4',
          'seed': '0.14',
          'name': 'Creed',
          'info': 'Scranton Strangler',
          'rating': '${Random().nextInt(6)}'
        },
      ),
    ];
    // userData = List.generate(
    //   6,
    //   (index) {
    //     final radius = 60.0 + 60 * Random().nextInt(3);
    // return User(
    //   radius: radius,
    //   data: {
    //     'radius': (radius).toString(),
    //     'index': '$index',
    //     'seed': '${Random().nextDouble() * 0.99}',
    //     'name': 'Mr Bean',
    //     'info': 'Teacher',
    //     'rating': '${Random().nextInt(6)}'
    //   },
    // );
    //   },
    // ).toList();
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
