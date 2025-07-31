import 'package:flutter/material.dart';

class UiHelper {
  static text(
    String text, {
    double? fontSize,
    Color? color,
    FontWeight? weight,
  }) {
    return Text(
      text,
      style: TextStyle(fontSize: fontSize, color: color, fontWeight: weight),
    );
  }
}
