part of 'home_bloc.dart';

abstract class HomeEvent {}
class LoadHomeDataEvent extends HomeEvent{}
class UpdateCategoryMovieEvent extends HomeEvent{
  String category;
  int page;
  UpdateCategoryMovieEvent(this.category,this.page);
}
class UpdateMovieEvent extends HomeEvent{
  String category;
  UpdateMovieEvent(this.category);
}
class SearchMovieEvent extends HomeEvent{
  String query;
  SearchMovieEvent(this.query);
}