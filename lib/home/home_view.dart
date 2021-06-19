import 'dart:ui';

import 'package:faller/home/home_viewmodel.dart';
import 'package:faller/utils/animations/orbit_painter.dart';
import 'package:faller/utils/models/user.dart';
import 'package:faller/utils/widgets/circular_image.dart';
import 'package:faller/utils/widgets/orbit_widget.dart';
import 'package:faller/utils/widgets/rotating_user_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:stacked/stacked.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      onModelReady: (model) => model.init(
          width: MediaQuery.of(context).size.width, tickerProvider: this),
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
                    height: model.width,
                    width: model.width,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ...orbitWidgets(model.animationValue),
                        ...planets(model)
                      ],
                    ),
                  )));
      },
    );
  }

  List<OrbitWidget> orbitWidgets(double animationValue) {
    return List.generate(
        3,
        (index) => OrbitWidget(
            animationValue: animationValue, radius: 60 * (index + 1))).toList();
  }

  List<RotatingUserImage> planets(HomeViewModel model) {
    return List.generate(
        model.userData.length,
        (index) => RotatingUserImage(
            onTap: model.toggleMenu,
            isOpen: model.userData[index].isOpen,
            offset: model.calculate(
                model.animationValue, model.userData[index].path, index),
            data: model.userData[index].data)).toList();
  }
}
