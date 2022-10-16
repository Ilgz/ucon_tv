import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:new_ucon/constants.dart';
import 'package:new_ucon/model/slider.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import '../model/film.dart';
part 'home_event.dart';
part 'home_state.dart';
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<LoadHomeDataEvent>(_loadHomeDataEvent);
  }
  Future<void> _loadHomeDataEvent(LoadHomeDataEvent event,Emitter<HomeState> emit) async {
    String requestSlidersUrl="${myServer}Updating/Sliders/";
    var client = http.Client();
    try{
      final responseSlider= await client.get(Uri.parse(requestSlidersUrl));
      final resultSlider=sliderFromJson(responseSlider.body);
      final premierList=await getUpdates(client,"soon","Premiers");
      final filmList=await getUpdates(client, "allfilms", "Films");
      //final serialList=await getUpdates(client, "allfilms", "Serials");
      //emit(LoadHomeDataSuccessState(resultSlider,premierList..addAll(filmFromJson(await loadAsset("Premiers.txt")))));
      emit(LoadHomeDataSuccessState(resultSlider,filmList..addAll(filmFromJson(await loadAsset("Films.txt"))),premierList..addAll(filmFromJson(await loadAsset("Premiers.txt"))),));
    }
    finally {
      client.close();
    }


  }
  Future<List<Film>> getUpdates(http.Client client,String category,String initial_repo)async {
    List<Film> finalList=[];
    int premierPage=1;
    while(finalList.isEmpty||(finalList.length % 20)==0) {
      String url ="https://kinotochka.co/$category/page/${premierPage}/";
      final response = await client.get(
          Uri.parse(url));
      dom.Document html = dom.Document.html(response.body);
      final title = html.getElementsByClassName("custom1-title").map((e) =>
          e.innerHtml.trim()).toList();
      final image = html.getElementsByClassName("xfieldimage mini_poster").map((
          e) => e.attributes['src']).toList();
      final site = html.getElementsByClassName("custom1-img").map((e) =>
      e.attributes['href']).toList();
      List<Film> premierList = filmFromJson( await loadAsset("${initial_repo}.txt"));
      for (int x = category=="soon"?0:15; x < image.length; x++) {
        bool isIncluded = false;
        for (int i = 0; i < premierList.length; i++) {
          if (title[x] == premierList[i].name) {
            print("is included"+ title[x]+premierList[i].name);
            isIncluded = true;
          }
        }
        if (!isIncluded) {
          String errorExcludedTitle=title[x].replaceAll("\"", "\'");
          finalList.add(
              Film(name: errorExcludedTitle+"fuck", imageLink: image[x]!, siteLink: site[x]!));
        } else {
          print("unadded"+title[x]);
          return finalList;
        }
      }
      premierPage++;
    }

    return finalList;



  }
  Future<String> loadAsset(String name) async {
    return await rootBundle.loadString('assets/movie_repo/${name}');
  }
}
