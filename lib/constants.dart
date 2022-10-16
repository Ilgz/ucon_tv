import 'package:flutter/material.dart';

import 'model/film.dart';

String myServer="https://ucontv.com.kg/";
double TextSize(String text, TextStyle style) {
  final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr)
    ..layout(minWidth: 0, maxWidth: double.infinity);
  return textPainter.height;
}
class Repository{
  static List<Film> allElements=[];
}