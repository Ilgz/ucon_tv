// To parse this JSON data, do
//
//     final channel = channelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<ChannelCategory> channelCategoryFromJson(String str) => List<ChannelCategory>.from(json.decode(str).map((x) => ChannelCategory.fromJson(x)));


class ChannelCategory {
  ChannelCategory({
    required this.newid,
    required this.name,
    required this.link,
  });

  String newid;
  String name;
  String link;

  factory ChannelCategory.fromJson(Map<String, dynamic> json) => ChannelCategory(
    newid: json["newid"],
    name: json["Name"],
    link: json["Link"],
  );

  Map<String, dynamic> toJson() => {
    "newid": newid,
    "Name": name,
    "Link": link,
  };
}
