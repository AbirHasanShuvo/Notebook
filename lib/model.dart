import 'package:flutter/cupertino.dart';

enum Category { Red, Blue, Green, Orange, Grey, Yellow, Violet, Silver }

class ModelClass {
  const ModelClass(
      {required this.title, required this.description, required this.color});

  final String title;
  final String description;
  final Color color;
}
