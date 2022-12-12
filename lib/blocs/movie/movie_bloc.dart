import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:html/dom.dart' as dom;
import 'package:chitose/chitose.dart';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'dart:convert';

import '../../data/constants.dart';


part 'movie_event.dart';

part 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  MovieBloc() : super(MovieInitial()) {
    on<LoadFilmLinkEvent>(_loadFilmLinkEvent);
    on<DisposeMovieEvent>(_disposeMovieEvent);
    on<SeekBarUpdateEvent>(_seekBarUpdateEvent);
    on<ChangeSeriesEvent>(_changeSeriesEvent);
    on<VideoIsPaused>((event,emit)=>emit(VideoIsPausedState(event.isPaused)));
  }
  Future<void> _changeSeriesEvent (ChangeSeriesEvent event,Emitter<MovieState> emit)async{
    List<String> stream=await getStream("initCDNSeriesEvents", event.movieId, event.translatorId, event.season, event.episode,"");
   emit(ChangeSeriesSuccessState(stream[0]));
  }
  Future<void> _seekBarUpdateEvent(
      SeekBarUpdateEvent event, Emitter<MovieState> emit) async {
    emit(SeekBarUpdateState(event.length, event.currentPosition,
        formatterTime(event.currentPosition), formatterTime(event.length)));
  }

  String formatterTime(int timeInSeconds) {
    String formattedString = "";
    int seconds = timeInSeconds;
    int minutes = 0;
    int hours = 0;
    while (true) {
      if ((seconds - 60) >= 0) {
        seconds -= 60;
        minutes++;
      } else {
        break;
      }
    }
    while (true) {
      if ((minutes - 60) >= 0) {
        minutes -= 60;
        hours++;
      } else {
        break;
      }
    }
    formattedString += seconds.toString().length == 1
        ? "0" + seconds.toString()
        : seconds.toString();
    String minutesFormatted = minutes.toString().length == 1
        ? "0" + minutes.toString()
        : minutes.toString();
    String hoursFormatted = "";
    if (hours.toString() != "0") {
      hoursFormatted = (hours.toString().length == 1
              ? "0" + hours.toString()
              : hours.toString()) +
          ":";
    }
    formattedString = hoursFormatted + minutesFormatted + ":" + formattedString;
    return formattedString;
  }

  Future<void> _disposeMovieEvent(
      DisposeMovieEvent event, Emitter<MovieState> emit) async {
    emit(MovieInitial());
  }

  Future<void> _loadFilmLinkEvent(
      LoadFilmLinkEvent event, Emitter<MovieState> emit) async {
    emit(LoadFilmLinkLoadingState());
    if(event.filmLink.contains(".html")){
      List<String> streamData=await getDetails(event.filmLink);
      String streamLink=streamData[0];
      print(streamLink);
      if(streamData[1]=="initCDNSeriesEvents"){
        var episodes=await getEpisodes(streamData[2], streamData[3]);
        emit(LoadFilmLinkSuccessState(filmLink: streamLink,episodes: episodes,movieId: streamData[2],translatorId: streamData[3],description: streamData.last));
      }else{
        emit(LoadFilmLinkSuccessState(filmLink: streamLink,movieId: streamData[2],translatorId: streamData[3],description: streamData.last));
      }
    }else{
      emit(LoadFilmLinkSuccessState(filmLink: event.filmLink,movieId: "",translatorId:"" ,description: ""));

    }

  }
  Future<List<int>> getEpisodes(String id,String translatorId) async{
    List<int> episodeList=[];
    Map dataSerial = {'id': id, 'translator_id': translatorId, 'action': 'get_episodes'};
    final response = await http
        .post(Uri.parse("https://rezka.ag/ajax/get_cdn_series/"), body: dataSerial);
    dom.Document episodes = dom.Document.html(jsonDecode(response.body)['episodes']);
    episodes.getElementsByClassName("b-simple_episode__item").forEach((element) {
      int episode= int.parse(element.attributes['data-episode_id']!);
        episodeList.add(episode);
    });
    return episodeList;
  }
  Future<List<String>> getDetails(String siteLink,{int season=1,int episode=1})async{
    late String translatorId;
    late String movieId;
    String  contentType="";
    String description="";
    if(siteLink[0]=="/"){
      siteLink=rezkaServer+siteLink;
    }
    final pageResponse = await http
        .get(Uri.parse(siteLink));
    dom.Document html = dom.Document.html(pageResponse.body);
    html.getElementsByTagName("meta").forEach((element) {
      if(element.attributes['property']=="og:type"){
        if(element.attributes['content']! =="video.tv_series"){
          contentType='initCDNSeriesEvents';
        }else{
          contentType='initCDNMoviesEvents';
        }
      }

    }
    );
    description=html.getElementsByClassName("b-post__description_text").first.text;
    if(html.getElementById("translators-list") != null){
      translatorId=html.getElementById("translators-list")
      !.children.first.attributes['data-translator_id']!;
      var tmp = html.body!.text.split("sof.tv.$contentType").last.split("{")[0];
      movieId= tmp.split(',')[0].trim();
    }else{
      var tmp = html.body!.text.split("sof.tv.$contentType").last.split("{")[0];
      translatorId= tmp.split(",")[1].trim();
      movieId= tmp.split(',')[0].trim();
    }
    movieId=movieId.replaceAll("(", "");
  return   getStream(contentType,movieId,translatorId,1,1,description);

  }
  Future<List<String>> getStream(String contentType,String movieId,String translatorId,int season,int episode,String description)async{
    Map data=contentType=="initCDNMoviesEvents"?{'id': movieId, 'translator_id': translatorId, 'action': 'get_movie'}:{'id': movieId, 'translator_id': translatorId, 'season': season.toString(), 'episode': episode.toString(), 'action': 'get_stream'};
    final response = await http
        .post(Uri.parse("https://rezka.ag/ajax/get_cdn_series/"), body: data);
    String rawList = jsonDecode(response.body)['url'].toString();
    List<String> trashList = ["@", "#", "!", "^", "\$"];
    List<String> trashCodesSet = [];
    for (int i = 2; i < 4; i++) { 
      String startChar = '';
      for (final chars in trashList.product(i)) {
        var dataBytes = utf8.encode(chars.join(startChar));
        var trashCombo = base64Encode(dataBytes);
        trashCodesSet.add(trashCombo);
      }
    }
    String trashString = rawList.replaceAll("#h", "").split("//_//").join('');
    for (var i in trashCodesSet) {
      trashString = trashString.replaceAll(i, "");
    }
    List<String> finalString =
    utf8.decode(base64Decode(trashString)).split(",");
    String? finalLink;
    for (var element in finalString) {
      if(element.split("[")[1].split("]")[0]=="1080p"){
        finalLink=element.split("[")[1].split("]")[1].split(" or ")[1];
        break;
      }
    }
    if(finalLink==null){
      finalLink=finalString.last.split("[")[1].split("]")[1].split(" or ")[1];
    }
    return [finalLink,contentType,movieId,translatorId,description];
  }
}
