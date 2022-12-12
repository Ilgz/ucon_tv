import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:new_ucon/data/constants.dart';
import 'package:new_ucon/models/film_model.dart';
part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc() : super(CategoryInitial()) {
    on<UpdateCategoryMovieEvent>(_updateCategoryMovieEvent);
    on<CategoryActionMovieRightEvent>((event,emit)=>emit(CategoryActionMovieRightState(event.index)));
    on<CategoryActionMovieLeftEvent>((event,emit)=>emit(CategoryActionMovieLeftState(event.index)));
    on<CategoryActionMovieUpEvent>((event,emit)=>emit(CategoryActionMovieUpState(event.index)));
    on<CategoryActionMovieDownEvent>((event,emit)=>emit(CategoryActionMovieDownState(event.index)));
  }
  Future<void> _updateCategoryMovieEvent(UpdateCategoryMovieEvent event, Emitter<CategoryState> emit) async{
    if(event.page==1){
      emit(UpdateCategoryMovieLoading());
    }
    late String category;
    if(event.category=="Фильмы"){
      category="films";

    }else if(event.category=="Сериалы"){
      category="series";
    }else if(event.category=="Мультфильмы"){
      category="cartoons";
    }
    else if(event.category=="Премьеры"){
      category="premiers";
    }
    else{
      category=event.category;
    }
    var client = http.Client();
    try{
      if(category=="reco"){
         final movieList=await getRecommendation(client);
         emit(UpdateCategoryMovieSuccess(movieList, event.page));
      }else{
        final movieList=await getMovies(client, category,event.page);
        emit(UpdateCategoryMovieSuccess(movieList,event.page));
      }

    } finally {
      client.close();
    }

  }
  Future<List<Film>> getRecommendation(http.Client client)async {
    final response=await client.get(Uri.parse(HomeClass.recommendationLink));
    return filmFromJson(utf8.decode(response.bodyBytes));
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
