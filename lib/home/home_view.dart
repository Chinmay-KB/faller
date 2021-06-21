import 'dart:math';
import 'dart:ui';

import 'package:faller/home/home_viewmodel.dart';
import 'package:faller/utils/animations/orbit_painter.dart';
import 'package:faller/utils/colors.dart';
import 'package:faller/utils/models/user.dart';
import 'package:faller/utils/widgets/blast_widget.dart';
import 'package:faller/utils/widgets/circular_image.dart';
import 'package:faller/utils/widgets/orbit_widget.dart';
import 'package:faller/utils/widgets/polka_dot.dart';
import 'package:faller/utils/widgets/rotating_user_image.dart';
import 'package:faller/utils/widgets/search_button.dart';
import 'package:faller/utils/widgets/sun_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:stacked/stacked.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  final polkadots = List.generate(
    12,
    (index) {
      final random = Random();
      final radius = 10.0 + random.nextInt(10);
      final colorChoice = random.nextInt(AppColors.PASTEL_COLORS.length);
      return PolkaDot(
          alignment: Alignment(
              1 - random.nextDouble() * 2, 0.6 - random.nextDouble() * 1.5),
          radius: radius,
          colorChoice: colorChoice);
    },
  ).toList();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      onModelReady: (model) => model.init(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          tickerProvider: this),
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
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                          colors: [Color(0xFF6459C7), Color(0xff0f0c29)],
                          radius: .5),
                    ),
                    height: model.height,
                    width: model.width,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ...polkadots,
                        ...orbitWidgets(model),
                        ...planets(model),
                        SunWidget(model: model),
                        SearchButton(
                          model: model,
                        ),
                        BlastWidget(model: model),
                      ],
                    ),
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
            radius: model.orbits[index].radius * model.radiusValue)).toList();
  }

  List<RotatingUserImage> planets(HomeViewModel model) {
    return List.generate(
        model.userData.length,
        (index) => RotatingUserImage(
            image: model.userData[index].image,
            width: model.width,
            onTap: model.toggleMenu,
            isOpen: model.userData[index].isOpen,
            radius: 40,
            offset: model.calculate(
                model.animationValue,
                model.drawPath(model.userData[index].radius * model.radiusValue,
                    model.isBang),
                double.parse(model.userData[index].data['seed']!)),
            data: model.userData[index].data)).toList();
  }
}
