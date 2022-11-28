// To parse this JSON data, do
//
//     final channel = channelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<Channel> channelFromJson(String str) => List<Channel>.from(json.decode(str).map((x) => Channel.fromJson(x)));

String channelToJson(List<Channel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Channel {
  Channel({
    required this.name,
    required this.link,
  });

  String name;
  String link;

  factory Channel.fromJson(Map<String, dynamic> json) => Channel(
    name: json["Name"],
    link: json["Link"],
  );

  Map<String, dynamic> toJson() => {
    "Name": name,
    "Link": link,
  };
}
