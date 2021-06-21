import 'package:faller/home/home_viewmodel.dart';
import 'package:faller/utils/widgets/planet_widget.dart';
import 'package:flutter/material.dart';

/// Widget to show sun, handled separately than other planets
class SunWidget extends StatelessWidget {
  /// Holding HomeViewModel reference
  final HomeViewModel model;

  /// Constructor for [SunWidget]
  const SunWidget({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlanetWidget(
      image: model.sun.image,
      width: model.width,
      onTap: (x) => model.toggleSun(),
      isOpen: model.sun.isOpen,
      radius: 60,
      offset: Offset((model.width - 60) / 2, (model.height - 60) / 2),
      data: model.sun.data,
    );
  }
}
