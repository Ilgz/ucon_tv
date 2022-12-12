part of 'movie_bloc.dart';

@immutable
abstract class MovieState extends Equatable {}

class MovieInitial extends MovieState {
  @override
  List<Object> get props=>[];
}
class LoadFilmLinkSuccessState extends MovieState{
  String filmLink;
  List<int>? episodes;
  String translatorId;
  String movieId;
  String description;
  LoadFilmLinkSuccessState({this.filmLink="",this.episodes,required this.movieId,required this.translatorId,required this.description});
  @override
  List<Object> get props => [filmLink, episodes != null];
}
class ChangeSeriesSuccessState extends MovieState{
  final String filmLink;
  ChangeSeriesSuccessState(this.filmLink);
  @override
  List<Object> get props=>[filmLink];
}
class LoadFilmLinkLoadingState extends MovieState{
  @override
  List<Object> get props=>[];
}
class SeekBarUpdateState extends MovieState{
  int length;
  int currentPosition;
  String textLength;
  String textCurrent;
  SeekBarUpdateState(this.length,this.currentPosition,this.textCurrent,this.textLength);
  @override
  List<Object> get props=>[length,currentPosition,textLength,textCurrent];
}
class VideoIsPausedState extends MovieState{
  bool isPaused;
  VideoIsPausedState(this.isPaused);
  @override
  List<Object> get props=>[isPaused];
}