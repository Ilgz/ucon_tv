import 'dart:async';
import 'dart:async' show Future;
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;
import 'package:new_ucon/data/channels.dart';
import 'package:new_ucon/data/constants.dart';
import 'package:new_ucon/models/channel_category_model.dart';
import 'package:new_ucon/models/channel_model.dart';
import 'package:new_ucon/models/slider_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/film_model.dart';


part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  bool doubleBackToExitPressedOnce=false;
  int _filmPage=1;
  int _seriesPage=1;
  int _cartoonsPage=1;
  HomeBloc() : super(HomeInitial()) {
    on<LoadHomeDataEvent>(_loadHomeDataEvent);
    on<HomeBackButtonEvent>((event,emit){
    if(doubleBackToExitPressedOnce){
      emit(HomeBackButtonSuccessState());
      return;
    }
    doubleBackToExitPressedOnce=true;
    emit(HomeBackButtonWarningState());
    Timer(Duration(seconds: 2), () {
      doubleBackToExitPressedOnce=false;
    });
    });

    on<CheckRegistrationEvent>((event,emit)async{
      final prefs = await SharedPreferences.getInstance();
      final int? server = prefs.getInt('server');
      await Future.delayed(const Duration(milliseconds: 2000), () {
        emit(CheckRegistrationState(server));
      });

    });
    on<UpdateMovieTwoEvent>(_updateMovieEvent);
    on<UpdateMovieThreeEvent>(_updateMovieThreeEvent);
    on<SearchMovieEvent>(_searchMovieEvent);
    on<ActionProfileSliderEvent>((event,emit)=>emit(ActionProfileSliderState()));
    on<ActionProfileSearchEvent>((event,emit)=>emit(ActionProfileSearchState()));
    on<ActionSliderSearchEvent>((event,emit)=>emit(ActionSliderSearchState()));
    on<ActionSliderRebuildEvent>((event,emit)=>emit(ActionSliderRebuildState()));
    on<ActionSliderCategoryOneEvent>((event,emit)=>emit(ActionSliderCategoryOneState()));
    on<ActionCategoryMovieOneEvent>((event,emit)=>emit(ActionCategoryMovieOneState()));
    on<ActionMovieOneRowOneEvent>((event,emit)=>emit(ActionMovieOneRowOneState()));
    on<ActionRowOneRowTwoEvent>((event,emit)=>emit(ActionRowOneRowTwoState()));
    on<ActionMovieTwoCategoryThreeEvent>((event,emit)=>emit(ActionMovieTwoCategoryThreeState()));
    on<ActionMovieThreeCategoryThreeEvent>((event,emit)=>emit(ActionMovieThreeCategoryThreeState()));
    on<ActionRowTwoCategoryTwoEvent>((event,emit)=>emit(ActionRowTwoCategoryTwoState()));
    on<ActionCategoryTwoMovieTwoEvent>((event,emit)=>emit(ActionCategoryTwoMovieTwoState()));
    on<ActionRowOneRightEvent>((event,emit)=>emit(ActionRowOneRightState(event.index)));
    on<ActionRowTwoRightEvent>((event,emit)=>emit(ActionRowTwoRightState(event.index)));
    on<ActionRowTwoLeftEvent>((event,emit)=>emit(ActionRowTwoLeftState(event.index)));
    on<ActionRowOneLeftEvent>((event,emit)=>emit(ActionRowOneLeftState(event.index)));
    on<ActionMovieOneRightEvent>((event,emit)=>emit(ActionMovieOneRightState(event.index)));
    on<ActionMovieOneLeftEvent>((event,emit)=>emit(ActionMovieOneLeftState(event.index)));
    on<ActionMovieTwoRightEvent>((event,emit)=>emit(ActionMovieTwoRightState(event.index)));
    on<ActionMovieTwoLeftEvent>((event,emit)=>emit(ActionMovieTwoLeftState(event.index)));
    on<ActionMovieThreeRightEvent>((event,emit)=>emit(ActionMovieThreeRightState(event.index)));
    on<ActionMovieThreeLeftEvent>((event,emit)=>emit(ActionMovieThreeLeftState(event.index)));
    on<SearchActionMovieRightEvent>((event,emit)=>emit(SearchActionMovieRightState(event.index)));
    on<SearchActionMovieLeftEvent>((event,emit)=>emit(SearchActionMovieLeftState(event.index)));
    on<SearchActionMovieUpEvent>((event,emit)=>emit(SearchActionMovieUpState(event.index)));
    on<SearchActionMovieDownEvent>((event,emit)=>emit(SearchActionMovieDownState(event.index)));
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
      String detail=html.getElementsByClassName('b-content__inline_item-link')[i].children[1].text;
      _finalList.add(Film(name: name,imageLink: image,siteLink: site,details: detail));
    }
    emit(SearchMovieSuccessState(_finalList));

  }
  Future<void> _updateMovieThreeEvent(UpdateMovieThreeEvent event, Emitter<HomeState> emit) async{
    late int page;
    late String category;
      _seriesPage++;
      page=_seriesPage;
      category="series";
    var client = http.Client();
    try{
      final movieList=await getMovies(client, category,page);
      emit(UpdateMovieThreeSuccess(movieList,event.category));
    } finally {
      client.close();
    }

  }
  Future<void> _updateMovieEvent(UpdateMovieTwoEvent event, Emitter<HomeState> emit) async{
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
  emit(UpdateMovieTwoSuccess(movieList,event.category));
  } finally {
  client.close();
  }

  }
  Future<void> _loadHomeDataEvent(
      LoadHomeDataEvent event, Emitter<HomeState> emit) async {
    String requestSlidersUrl = "${myServer}Updating/Slider/";
    var client = http.Client();
    try {
      final responseSlider = await client.get(Uri.parse(requestSlidersUrl),);
      final resultSlider = sliderFromJson(responseSlider.body);
      final filmList=await getMovies(client, "films",1);
      final serialList = await getMovies(client, "series", 1);
      final cartoonList = await getMovies(client, "cartoons", 1);
      final premierList = await getMovies(client, "premiers", 1);
     await _getChannelLinks(client);
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
  Future<void> _getChannelLinks(http.Client client) async {
    final  response=await client.get(Uri.parse("https://ucontv.com.kg/info/update_links/"));
    List<ChannelCategory> channels=channelCategoryFromJson(response.body);
    //var channelClient = http.Client();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'User-Agent': 'PostmanRuntime/7.28.4'
    };
    for(var item in channels){
      if(item.name=="TCall"){

        final response=await client.get(Uri.parse(item.link),headers: requestHeaders);
        Channels.all=channelFromJson(utf8.decode(response.bodyBytes));
      }
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


    // });


    //  var decoded=jsonDecode(response.body)['seasons'];
    // var decoded2=jsonDecode(response.body)['episodes'];
    // print(decoded);
    // print(decoded2);

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
        String detail= html.getElementById("newest-slider-content")!.getElementsByClassName('b-content__inline_item-link')[i].children[1].text;
        _finalList.add(Film(name: name,imageLink: image,siteLink: site,details: detail));
      }
    }else{
      final response = await client.get(Uri.parse("https://rezka.ag/$category/page/$page/?filter=last"));
      dom.Document html = dom.Document.html(response.body);
      for(int i=0;i<html.getElementsByClassName('b-content__inline_item-cover').length;i++){
        String name=html.getElementsByClassName('b-content__inline_item-link')[i].children.first.text;
        String image=html.getElementsByClassName('b-content__inline_item-cover')[i].children.first.children.first.attributes["src"]!;
        String site=html.getElementsByClassName('b-content__inline_item-cover')[i].children.first.attributes["href"]!;
        String detail=html.getElementsByClassName('b-content__inline_item-link')[i].children[1].text;
        _finalList.add(Film(name: name,imageLink: image,siteLink: site,details: detail));
      };
    }


    return _finalList;



  }
}

