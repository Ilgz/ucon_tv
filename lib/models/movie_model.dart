import 'package:flutter/material.dart';

import 'film_model.dart';

class MovieElement {
  MovieElement({
    required this.sectionName,
    required this.sectionIndex,
  });
  String sectionName;
  List<Film> elements=[];
  List<FocusNode>? elementsFocus;
  FocusNode categoryFocus=FocusNode();
  int lastElement=0;
  int sectionIndex;
  ScrollController scrollController=ScrollController();
}