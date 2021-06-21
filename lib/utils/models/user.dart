import 'package:flutter/material.dart';

class User {
  bool isOpen = false;
  final double radius;
  final Map<String?, String?> data;
  final ImageProvider image;

  User({required this.data, required this.radius, required this.image});

  toggleDialog() => isOpen = !isOpen;
}
