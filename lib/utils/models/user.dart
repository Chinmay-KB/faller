import 'package:flutter/material.dart';

class User {
  bool isOpen = false;
  final double radius;
  final Map<String, String> data;

  User({required this.data, required this.radius});

  toggleDialog() => isOpen = !isOpen;
}
