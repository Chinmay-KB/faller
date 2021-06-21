import 'package:faller/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_portal/flutter_portal.dart';

void main() {
  runApp(
    const Portal(
      child: MaterialApp(
        home: HomeView(),
      ),
    ),
  );
}
