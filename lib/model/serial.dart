// To parse this JSON data, do
//
//     final playlist = playlistFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Playlist playlistFromJson(String str) => Playlist.fromJson(json.decode(str));

String playlistToJson(Playlist data) => json.encode(data.toJson());

class Playlist {
  Playlist({
    required this.playlist,
  });

  List<PlaylistElement> playlist;

  factory Playlist.fromJson(Map<String, dynamic> json) => Playlist(
    playlist: List<PlaylistElement>.from(json["playlist"].map((x) => PlaylistElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "playlist": List<dynamic>.from(playlist.map((x) => x.toJson())),
  };
}

class PlaylistElement {
  PlaylistElement({
    required this.comment,
    required this.file,
  });

  String comment;
  String file;

  factory PlaylistElement.fromJson(Map<String, dynamic> json) => PlaylistElement(
    comment: json["comment"],
    file: json["file"],
  );

  Map<String, dynamic> toJson() => {
    "comment": comment,
    "file": file,
  };
}
