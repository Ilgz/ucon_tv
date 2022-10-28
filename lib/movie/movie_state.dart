part of 'movie_bloc.dart';

@immutable
abstract class MovieState {}

class MovieInitial extends MovieState {}
class LoadFilmLinkSuccessState extends MovieState{
  String filmLink;
  LoadFilmLinkSuccessState(this.filmLink);
}
class LoadFilmLinkLoadingState extends MovieState{
}
class SeekBarUpdateState extends MovieState{
  int length;
  int currentPosition;
  String textLength;
  String textCurrent;
  SeekBarUpdateState(this.length,this.currentPosition,this.textCurrent,this.textLength);
}