part of 'home_bloc.dart';

abstract class HomeEvent {}
class LoadHomeDataEvent extends HomeEvent{}
class CheckRegistrationEvent extends HomeEvent{}
class HomeBackButtonEvent extends HomeEvent{}
class UpdateMovieThreeEvent extends HomeEvent {
  String category;
  UpdateMovieThreeEvent(this.category);
}
class UpdateMovieTwoEvent extends HomeEvent {
  String category;
  UpdateMovieTwoEvent(this.category);
}
class SearchMovieEvent extends HomeEvent{
  String query;
  SearchMovieEvent(this.query);
}
class ActionProfileSliderEvent extends HomeEvent{}
class ActionProfileSearchEvent extends HomeEvent{}
class ActionSliderRebuildEvent extends HomeEvent{}
class ActionSliderSearchEvent extends HomeEvent{}
class ActionSliderCategoryOneEvent extends HomeEvent{}
class ActionCategoryMovieOneEvent extends HomeEvent{}
class ActionCategoryTwoMovieTwoEvent extends HomeEvent{}
class ActionMovieOneRowOneEvent extends HomeEvent{}
class ActionMovieTwoCategoryThreeEvent extends HomeEvent{}
class ActionMovieThreeCategoryThreeEvent extends HomeEvent{}
class ActionRowOneRowTwoEvent extends HomeEvent{}
class ActionRowTwoCategoryTwoEvent extends HomeEvent{}
class ActionRowOneLeftEvent extends HomeEvent{
  int index;
  ActionRowOneLeftEvent(this.index);
}
class ActionRowTwoLeftEvent extends HomeEvent{
  int index;
  ActionRowTwoLeftEvent(this.index);
}
class ActionRowTwoRightEvent extends HomeEvent{
  int index;
  ActionRowTwoRightEvent(this.index);
}
class ActionRowOneRightEvent extends HomeEvent{
  int index;
  ActionRowOneRightEvent(this.index);
}
class ActionMovieOneLeftEvent extends HomeEvent{
  int index;
  ActionMovieOneLeftEvent(this.index);
}
class ActionMovieOneRightEvent extends HomeEvent{
  int index;
  ActionMovieOneRightEvent(this.index);
}
class ActionMovieTwoRightEvent extends HomeEvent{
  int index;
  ActionMovieTwoRightEvent(this.index);
}
class ActionMovieTwoLeftEvent extends HomeEvent{
  int index;
  ActionMovieTwoLeftEvent(this.index);
}
class ActionMovieThreeRightEvent extends HomeEvent{
  int index;
  ActionMovieThreeRightEvent(this.index);
}
class ActionMovieThreeLeftEvent extends HomeEvent{
  int index;
  ActionMovieThreeLeftEvent(this.index);
}
class SearchActionMovieRightEvent extends HomeEvent {
  int index;

  SearchActionMovieRightEvent(this.index);
}

class SearchActionMovieLeftEvent extends HomeEvent {
  int index;

  SearchActionMovieLeftEvent(this.index);
}

class SearchActionMovieUpEvent extends HomeEvent {
  int index;
  SearchActionMovieUpEvent(this.index);
}
class SearchActionMovieDownEvent extends HomeEvent {
  int index;
  SearchActionMovieDownEvent(this.index);
}