import 'package:flutter/material.dart';

import 'film.dart';

class MovieElement {
  MovieElement({
    required this.sectionName,
    required this.sectionIndex,
  });
  String sectionName;
  List<Film> elements=[];
  List<FocusNode>? elementsFocus;
  int lastElement=0;
  int sectionIndex;
  ScrollController scrollController=ScrollController();
}