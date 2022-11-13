part of 'movie_bloc.dart';

@immutable
abstract class MovieEvent {}
class LoadFilmLinkEvent extends MovieEvent{
  String filmLink;
  String filmName;
  LoadFilmLinkEvent(this.filmLink,this.filmName);
}
class DisposeMovieEvent extends MovieEvent{}
class ChangeSeriesEvent extends MovieEvent{
  int season;
  int episode;
  String movieId;
  String translatorId;
  ChangeSeriesEvent(this.season,this.episode,this.movieId,this.translatorId);
}
class SeekBarUpdateEvent extends MovieEvent{
  int length;
  int currentPosition;
  SeekBarUpdateEvent(this.length,this.currentPosition);
}