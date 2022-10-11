// To parse this JSON data, do
//
//     final slider = sliderFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<Slider> sliderFromJson(String str) => List<Slider>.from(json.decode(str).map((x) => Slider.fromJson(x)));

String sliderToJson(List<Slider> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Slider {
  Slider({
    required this.name,
    required this.link,
    required this.intentTitle,
    required this.intentImgUrl,
    required this.intentSiteLink,
    required this.intentType,
    required this.idBar,
  });

  String name;
  String link;
  String intentTitle;
  String intentImgUrl;
  String intentSiteLink;
  String intentType;
  String idBar;

  factory Slider.fromJson(Map<String, dynamic> json) => Slider(
    name: json["Name"],
    link: json["Link"],
    intentTitle: json["intentTitle"],
    intentImgUrl: json["intentImgUrl"],
    intentSiteLink: json["intentSiteLink"],
    intentType: json["intentType"],
    idBar: json["idBar"],
  );

  Map<String, dynamic> toJson() => {
    "Name": name,
    "Link": link,
    "intentTitle": intentTitle,
    "intentImgUrl": intentImgUrl,
    "intentSiteLink": intentSiteLink,
    "intentType": intentType,
    "idBar": idBar,
  };
}





