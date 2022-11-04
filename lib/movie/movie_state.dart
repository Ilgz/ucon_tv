part of 'movie_bloc.dart';

@immutable
abstract class MovieState {}

class MovieInitial extends MovieState {}
class LoadFilmLinkSuccessState extends MovieState{
  String filmLink;
  List<PlaylistElement>? playlist;
  LoadFilmLinkSuccessState({this.filmLink="",this.playlist});
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