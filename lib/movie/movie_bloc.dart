import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

part 'movie_event.dart';

part 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  MovieBloc() : super(MovieInitial()) {
    on<LoadFilmLinkEvent>(_loadFilmLinkEvent);
    on<DisposeMovieEvent>(_disposeMovieEvent);
on<SeekBarUpdateEvent>(_seekBarUpdateEvent);

  }
  Future<void> _seekBarUpdateEvent(SeekBarUpdateEvent event,Emitter<MovieState> emit)async{
    emit(SeekBarUpdateState(event.length, event.currentPosition, formatterTime(event.currentPosition),formatterTime(event.length)));
  }
  String formatterTime(int timeInSeconds){
    String formattedString="";
    int seconds=timeInSeconds;
    int minutes=0;
    int hours=0;
    while(true){
      if((seconds-60)>=0){
        seconds-=60;
        minutes++;
      }else{
        break;
      }
    }
    while(true){

      if((minutes-60)>=0){
        minutes-=60;
        hours++;
      }else{
        break;
      }
    }
    formattedString+=seconds.toString().length==1?"0"+seconds.toString():seconds.toString();
    String minutesFormatted=minutes.toString().length==1?"0"+minutes.toString():minutes.toString();
    String hoursFormatted="";
    if(hours.toString()!="0"){
      hoursFormatted=(hours.toString().length==1?"0"+hours.toString():hours.toString())+":";
    }
   formattedString=hoursFormatted+minutesFormatted+":"+formattedString;
    return formattedString;
  }
  Future<void> _disposeMovieEvent(DisposeMovieEvent event,Emitter<MovieState> emit)async{
    emit(MovieInitial());
  }
  Future<void> _loadFilmLinkEvent(
      LoadFilmLinkEvent event, Emitter<MovieState> emit) async {
    emit(LoadFilmLinkLoadingState());
    final response = await http.get(Uri.parse(event.filmLink));
    dom.Document html = dom.Document.html(response.body);
    final title = html
        .getElementsByTagName("script")
        .map((e) => e.text.trim())
        .toList();
    for(final e in title){
      if(e.contains("playerjshd")){
        RegExp exp = new RegExp(r"((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?");
        Iterable<RegExpMatch> matches = exp.allMatches(e);
        for (var match in matches) {
          emit(LoadFilmLinkSuccessState(e.substring(match.start, match.end)));
        }
      }
    }

  }
}
