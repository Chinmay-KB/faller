import 'package:flutter/material.dart';

class User {
  bool isOpen = false;
  final Path path;
  final Map<String, String> data;

  User({required this.data, required this.path});

  toggleDialog() => isOpen = !isOpen;
}
