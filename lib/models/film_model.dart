// To parse this JSON data, do
//
//     final film = filmFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<Film> filmFromJson(String str) => List<Film>.from(json.decode(str).map((x) => Film.fromJson(x)));

String filmToJson(List<Film> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Film {
  Film({
    required this.name,
    required this.imageLink,
    required this.siteLink,
    required this.details
  });

  String name;
  String imageLink;
  String siteLink;
  String details;
  factory Film.fromJson(Map<String, dynamic> json) => Film(
    name: json["Name"],
    imageLink: json["ImageLink"],
    siteLink: json["FilmLink"],
    details: json["Details"]
  );

  Map<String, dynamic> toJson() => {
    "Name": name,
    "ImageLink": imageLink,
    "SiteLink": siteLink,
  };
}
