import 'dart:async';
import 'dart:async' show Future;
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:chitose/chitose.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;
import 'package:new_ucon/constants.dart';
import 'package:new_ucon/model/slider.dart';

import '../model/film.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  int _filmPage=1;
  int _seriesPage=1;
  int _cartoonsPage=1;
  HomeBloc() : super(HomeInitial()) {
    on<LoadHomeDataEvent>(_loadHomeDataEvent);
    on<UpdateMovieEvent>(_updateMovieEvent);
    on<SearchMovieEvent>(_searchMovieEvent);
  }
  Future<void> _searchMovieEvent(SearchMovieEvent event,Emitter<HomeState> emit)async{
    List<Film> _finalList = [];
    emit(SearchMovieLoadingState());
    final response = await http.get(Uri.parse("https://rezka.ag/search/?do=search&subaction=search&q=${event.query}&page=1"));
    dom.Document html = dom.Document.html(response.body);
    for(int i=0;i<html.getElementsByClassName('b-content__inline_item-cover').length;i++){
      String name=html.getElementsByClassName('b-content__inline_item-link')[i].children.first.text;
      String image=html.getElementsByClassName('b-content__inline_item-cover')[i].children.first.children.first.attributes["src"]!;
      String site=html.getElementsByClassName('b-content__inline_item-cover')[i].children.first.attributes["href"]!;
      _finalList.add(Film(name: name,imageLink: image,siteLink: site));
    }
    emit(SearchMovieSuccessState(_finalList));

  }
  Future<void> _updateMovieEvent(UpdateMovieEvent event, Emitter<HomeState> emit) async{
    late int page;
    late String category;
    if(event.category=="Фильмы"){
      _filmPage++;
      page=_filmPage;
      category="films";

    }else if(event.category=="Сериалы"){
      _seriesPage++;
      page=_seriesPage;
      category="series";
    }else if(event.category=="Мультфильмы"){
      _cartoonsPage++;
      page=_cartoonsPage;
      category="cartoons";
    }
  var client = http.Client();
  try{
  final movieList=await getMovies(client, category,page);
  emit(UpdateMovieSuccess(movieList,event.category));
  } finally {
  client.close();
  }

  }
  Future<void> _loadHomeDataEvent(
      LoadHomeDataEvent event, Emitter<HomeState> emit) async {
    //rezkaFilm();
    String requestSlidersUrl = "${myServer}Updating/Sliders/";
    var client = http.Client();
    try {
      //getEpisodes();
      rezkaApi();
      final responseSlider = await client.get(Uri.parse(requestSlidersUrl));
      final resultSlider = sliderFromJson(responseSlider.body);
      final filmList=await getMovies(client, "films",1);
      final serialList = await getMovies(client, "series", 1);
      final cartoonList = await getMovies(client, "cartoons", 1);
      final premierList = await getMovies(client, "premiers", 1);
      emit(LoadHomeDataSuccessState(
          resultSlider,
          filmList,
          cartoonList,
          serialList,
        premierList
      ));

    } finally {
      client.close();
    }
  }

  Future<void> getEpisodes()async{
    List<List<int>> episodeList=[];
     Map dataSerial = {'id': '45', 'translator_id': '111', 'action': 'get_episodes'};
    final response = await http
        .post(Uri.parse("https://rezka.ag/ajax/get_cdn_series/"), body: dataSerial);
     dom.Document episodes = dom.Document.html(jsonDecode(response.body)['episodes']);
       episodes.getElementsByClassName("b-simple_episode__item").forEach((element) {
        int episode= int.parse(element.attributes['data-episode_id']!);

         if(episode==1){
           episodeList.add([]);
         }
         episodeList.last.add(episode);
});

       episodeList.forEach((e) => print(e));

    // });


    //  var decoded=jsonDecode(response.body)['seasons'];
    // var decoded2=jsonDecode(response.body)['episodes'];
    // print(decoded);
    // print(decoded2);

  }
  Future<void> rezkaApi(
      ) async {
    late String translatorId;
    late String movieId;
    String  contentType="";
    final pageResponse = await http
        .get(Uri.parse("https://rezka.ag/series/fantasy/45-igra-prestolov-2011.html"));
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
    Map data=contentType=="initCDNMoviesEvents"?{'id': movieId.replaceAll("(", ""), 'translator_id': translatorId, 'action': 'get_movie'}:{'id': movieId.replaceAll("(", ""), 'translator_id': translatorId, 'season': '1', 'episode': '1', 'action': 'get_stream'};
    // Map dataSerial = {'id': '51367', 'translator_id': '55', 'season': '1', 'episode': '1', 'action': 'get_stream'};
    final response = await http
        .post(Uri.parse("https://rezka.ag/ajax/get_cdn_series/"), body: data);
    String rawList = jsonDecode(response.body)['url'].toString();
    List<String> trashList = ["@", "#", "!", "^", "\$"];
    List<String> trashCodesSet = [];
    for (int i = 2; i < 4; i++) {
      String startchar = '';
      for (final chars in trashList.product(i)) {
        var data_bytes = utf8.encode(chars.join(startchar));
        var trashcombo = base64Encode(data_bytes);
        trashCodesSet.add(trashcombo);
      }
    }
    String trashString = rawList.replaceAll("#h", "").split("//_//").join('');
    for (var i in trashCodesSet) {
      trashString = trashString.replaceAll(i, "");
    }
    List<String> finalString =
    utf8.decode(base64Decode(trashString)).split(",");
    print(finalString.last.split("[")[1].split("]")[1].split(" or ")[1]);
  }

  Future<List<Film>> getMovies(http.Client client,String category,int page)async{
    List<Film> _finalList = [];
    if(category=="premiers"){
      final response = await client.get(Uri.parse("https://rezka.ag"));
      dom.Document html = dom.Document.html(response.body);
      for(int i=0;i<html.getElementById("newest-slider-content")!.getElementsByClassName('b-content__inline_item-cover').length;i++){
        String name= html.getElementById("newest-slider-content")!.getElementsByClassName('b-content__inline_item-link')[i].children.first.text;
        String image= html.getElementById("newest-slider-content")!.getElementsByClassName('b-content__inline_item-cover')[i].children.first.children.first.attributes["src"]!;
        String site= html.getElementById("newest-slider-content")!.getElementsByClassName('b-content__inline_item-cover')[i].children.first.attributes["href"]!;
        _finalList.add(Film(name: name,imageLink: image,siteLink: site));
      }
    }else{
      final response = await client.get(Uri.parse("https://rezka.ag/${category}/page/${page}/?filter=last"));
      dom.Document html = dom.Document.html(response.body);
      for(int i=0;i<html.getElementsByClassName('b-content__inline_item-cover').length;i++){
        String name=html.getElementsByClassName('b-content__inline_item-link')[i].children.first.text;
        String image=html.getElementsByClassName('b-content__inline_item-cover')[i].children.first.children.first.attributes["src"]!;
        String site=html.getElementsByClassName('b-content__inline_item-cover')[i].children.first.attributes["href"]!;
        _finalList.add(Film(name: name,imageLink: image,siteLink: site));
      };
    }


    return _finalList;



  }
}

