import 'dart:math';
import 'dart:ui';

import 'package:faller/utils/models/orbit.dart';
import 'package:faller/utils/models/planet.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'package:vibration/vibration.dart';

/// ViewModel for `HomeView`
/// There are 4 types of animation controllers in play here.
/// -1. `_controllers` - are a list of `AnimationController`, each one dealing with
/// the rotation of a particular orbit and its planets.
///
/// -2. `_radiusanimationController' - This deals with decreasing the orbit and
/// planet rotation radius when the big bang starts.
///
/// -3. `_blastGlowAnimationController` - This deals with the radius and opacity
/// increase of the `RadialGradient` of yellow, for the bright light.
///
/// -4. `_spinSpeedIncreaseController` - This increases the rotation speed of
/// planets and orbits when big bang starts. The value of this controller is
/// passed as the duration to the `_controllers`, such that with every increase,
/// the duration decreases and hence increase in rotation speed.
class HomeViewModel extends BaseViewModel {
  // bool _isOpen = false;
  late double _width;
  late double _height;
  // late Path _path;
  late List<AnimationController> _controllers;
  // Number of orbits. Used for creating the rotation animation controllers
  final _orbitsNo = 3;
  late AnimationController _radiusAnimationController,
      _blastGlowAnimationController,
      _spinSpeedIncreaseController;
  late Animation _radiusAnimation, _blastGlowAnimation;
  late List<Orbit> _orbits;
  late List<Planet> _userData;
  // ignore: prefer_final_fields
  bool _isBang = false;
  bool _isInfoOpen = false;
  final _sun = Planet(
    radius: 0,
    seed: 0,
    orbit: -1,
    image: const AssetImage('assets/michaelscott.jpg'),
    data: {
      'index': '-1',
      'name': 'Michael Scott',
      'info': 'Regional Manager',
      'rating': '${Random().nextInt(6)}'
    },
  );

  /// Screen width
  double get width => _width;

  /// Screen height
  double get height => _height;

  /// Animation value for rotation
  double animationValue(index) => _controllers[index].value;

  /// Radius value animation. Triggered on big bang.
  double get radiusValue => _radiusAnimation.value;

  /// Blast radius value animation. Triggered on big bang.
  double get blastValue => _blastGlowAnimation.value;

  /// Returns `true` if big bang starts
  bool get isBang => _isBang;

  /// Data related to the sun.
  Planet get sun => _sun;

  /// List of all planets
  List<Planet> get userData => _userData;

  /// List of all the orbits
  List<Orbit> get orbits => _orbits;

  /// Animation controller of rotation animation.
  AnimationController controller(index) => _controllers[index];

  /// Handles `onTap` event of planets.
  toggleMenu(int index) {
    if (_isInfoOpen == false) {
      userData[index].toggleDialog();
      if (userData[index].isOpen) {
        _controllers[userData[index].orbit].stop();
        _isInfoOpen = true;
      }
      notifyListeners();
      // Restart rotation after 3 seconds
      Future.delayed(const Duration(milliseconds: 3000), () async {
        userData[index].toggleDialog();
        _controllers[userData[index].orbit].forward();
        _isInfoOpen = false;
      });
    }
  }

  /// Handles onTap event of sun. Handled separately as it has different properties
  /// TODO: Can be merged into `toggleMenu()`
  toggleSun() {
    if (_isInfoOpen == false) {
      sun.toggleDialog();
      if (sun.isOpen) {
        _isInfoOpen = true;
      }
      notifyListeners();
      Future.delayed(
        const Duration(milliseconds: 3000),
        () async {
          sun.toggleDialog();
          _isInfoOpen = false;
        },
      );
    }
  }

  /// Initialise ViewModel
  void init(
      {required double width,
      required double height,
      required TickerProvider tickerProvider}) async {
    setBusy(true);
    _width = width;
    _height = height;
    _spinSpeedIncreaseController = AnimationController(
        vsync: tickerProvider, duration: const Duration(milliseconds: 3000))
      // Not sure if this is a proper way to do this/
      ..addListener(
        () {
          _controllers.forEach(
            (_controller) {
              _controller.duration = Duration(
                  milliseconds: 1000 +
                      (9000 * (1 - _spinSpeedIncreaseController.value)).ceil());
              _controller.forward();
            },
          );
        },
      );
    _controllers = List.generate(
      _orbitsNo,
      (index) => AnimationController(
        vsync: tickerProvider,
        duration: const Duration(milliseconds: 20000),
      ),
    ).toList();
    _controllers.forEach((element) {
      element.addListener(() {
        if (element.isCompleted) element.repeat();
        notifyListeners();
      });
      element.forward();
    });

    _radiusAnimationController = AnimationController(
        value: 1,
        upperBound: 1,
        lowerBound: 0.000001,
        vsync: tickerProvider,
        duration: const Duration(milliseconds: 8000));
    _radiusAnimation = CurvedAnimation(
        parent: _radiusAnimationController,
        curve: Curves.easeIn,
        reverseCurve: Curves.easeIn);
    _blastGlowAnimationController = AnimationController(
        vsync: tickerProvider, duration: const Duration(milliseconds: 6000));
    _blastGlowAnimation = CurvedAnimation(
        parent: _blastGlowAnimationController, curve: Curves.easeInExpo);
    // Only for testing purposes

    initPlanetsData();
    initOrbitsData();
    setBusy(false);
  }

  /// Starts the big bang
  startBang() async {
    // As the planets and orbits collapse, the big bang should expand, hence the
    // reverse() for [_radiusAnimationController]
    _radiusAnimationController.reverse();
    _blastGlowAnimationController.forward();
    _isBang = true;
    _spinSpeedIncreaseController.forward();
    if ((await Vibration.hasAmplitudeControl())!) {
      Vibration.vibrate(
          duration: 2000,
          amplitude: (_blastGlowAnimationController.value * 255).toInt());
    } else {
      Vibration.vibrate(duration: 2000);
    }
  }

  /// Calculates position of a planet on the basis of the path provided
  // Throws an error when value passed is `0`. Hence the lower bounds of some
  // animations are `0.00001` rather than `0`.
  Offset calculate(double value, Path path, double seed) {
    PathMetrics pathMetrics = path.computeMetrics();
    PathMetric pathMetric = pathMetrics.elementAt(0);
    value = value + seed;
    if (value > 1) value = value - 1;
    value = pathMetric.length * value;
    Tangent? pos = pathMetric.getTangentForOffset(value);
    return pos!.position;
  }

  /// Calculates the path of a planet depending on the radius provided
  Path drawPath(double radius) {
    Path path = Path();
    final Rect rect = Rect.fromCircle(
        center: Offset((_width - 40) / 2, (height - 40) / 2), radius: radius);
    path.addOval(rect);

    return path;
  }

  /// Assign planets data to a list.
  initPlanetsData() {
    _userData = [
      Planet(
        radius: 60,
        image: const AssetImage('assets/dwight.jpg'),
        orbit: 0,
        seed: 0.3,
        data: {
          'radius': (60).toString(),
          'index': '0',
          'name': 'Dwight',
          'info': 'Beet farmer',
          'rating': '${Random().nextInt(6)}'
        },
      ),
      Planet(
        radius: 120,
        orbit: 1,
        seed: 0.4,
        image: const AssetImage('assets/jim.jpg'),
        data: {
          'radius': (120).toString(),
          'index': '1',
          'name': 'Jim',
          'info': 'Salesman',
          'rating': '${Random().nextInt(6)}'
        },
      ),
      Planet(
        radius: 180,
        orbit: 2,
        seed: 0.8,
        image: const AssetImage('assets/pam.jpg'),
        data: {
          'radius': (180).toString(),
          'index': '2',
          'name': 'Pam',
          'info': 'Receptionist',
          'rating': '${Random().nextInt(6)}'
        },
      ),
      Planet(
        radius: 180,
        seed: 0.6,
        image: const AssetImage('assets/ryan.jpg'),
        orbit: 2,
        data: {
          'radius': (180).toString(),
          'index': '3',
          'seed': '0.6',
          'name': 'Ryan',
          'info': 'Temp',
          'rating': '${Random().nextInt(6)}'
        },
      ),
      Planet(
        radius: 180,
        orbit: 2,
        seed: 0.14,
        image: const AssetImage('assets/creed.jpg'),
        data: {
          'radius': (180).toString(),
          'index': '4',
          'name': 'Creed',
          'info': 'Scranton Strangler',
          'rating': '${Random().nextInt(6)}'
        },
      ),
    ];
    // Used for testing purposes.
    // userData = List.generate(
    //   6,
    //   (index) {
    //     final radius = 60.0 + 60 * Random().nextInt(3);
    // return Planet(
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

  /// Assign orbits data to a list
  initOrbitsData() {
    _orbits = List.generate(
        3,
        (index) => Orbit(radius: 60 * (index + 1), data: {
              'level': '$index',
              'seed': '${Random().nextDouble() * 0.99}'
            }));
  }
}
