part of 'movie_bloc.dart';

@immutable
abstract class MovieEvent {}
class LoadFilmLinkEvent extends MovieEvent{
  String filmLink;
  LoadFilmLinkEvent(this.filmLink);
}
class DisposeMovieEvent extends MovieEvent{}
class SeekBarUpdateEvent extends MovieEvent{
  int length;
  int currentPosition;
  SeekBarUpdateEvent(this.length,this.currentPosition);
}