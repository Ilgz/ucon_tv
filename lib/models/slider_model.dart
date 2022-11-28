// To parse this JSON data, do
//
//     final slider = sliderFromJson(jsonString);

import 'dart:convert';

List<SliderModel> sliderFromJson(String str) => List<SliderModel>.from(json.decode(str).map((x) => SliderModel.fromJson(x)));

String sliderToJson(List<SliderModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SliderModel {
  SliderModel({
    required this.name,
    required this.sliderImage,
    required this.image,
    required this.site,
  });

  String name;
  String sliderImage;
  String image;
  String site;

  factory SliderModel.fromJson(Map<String, dynamic> json) => SliderModel(
    name: json["name"],
    sliderImage: json["sliderImage"],
    image: json["image"],
    site: json["site"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "sliderImage": sliderImage,
    "image": image,
    "site": site,
  };
}
