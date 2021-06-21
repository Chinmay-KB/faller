import 'package:faller/home/home_viewmodel.dart';
import 'package:faller/utils/widgets/rotating_user_image.dart';
import 'package:flutter/material.dart';

class SunWidget extends StatelessWidget {
  final HomeViewModel model;
  const SunWidget({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RotatingUserImage(
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
