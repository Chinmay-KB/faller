import 'dart:math';
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
          backgroundColor: Color(0xff0f0c29),
          body: model.isBusy
              ? Center(child: CircularProgressIndicator())
              : Center(
                  child: Stack(
                    children: [
                      Container(
                        height: 200,
                        width: 200,
                        color: Colors.amber,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                              colors: [Color(0xFF6459C7), Color(0xff0f0c29)],
                              radius: .5),
                        ),
                        height: model.width,
                        width: model.width,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            ...orbitWidgets(model),
                            ...planets(model),
                            //Handle this separately
                            RotatingUserImage(
                                onTap: (x) => null,
                                isOpen: false,
                                radius: 70,
                                offset: Offset((model.width - 70) / 2,
                                    (model.width - 70) / 2),
                                data: {
                                  'radius': (0).toString(),
                                  'index': '-1',
                                  'seed': '${Random().nextDouble() * 0.99}'
                                })
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }

  List<OrbitWidget> orbitWidgets(HomeViewModel model) {
    return List.generate(
        model.orbits.length,
        (index) => OrbitWidget(
            animationValue: model.animationValue,
            seed: double.parse(model.orbits[index].data['seed']!),
            radius: model.orbits[index].radius)).toList();
  }

  List<RotatingUserImage> planets(HomeViewModel model) {
    return List.generate(
        model.userData.length,
        (index) => RotatingUserImage(
            onTap: model.toggleMenu,
            isOpen: model.userData[index].isOpen,
            radius: 40,
            offset: model.calculate(
                model.animationValue,
                model.userData[index].path,
                double.parse(model.userData[index].data['seed']!)),
            data: model.userData[index].data)).toList();
  }
}
