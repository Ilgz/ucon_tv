part of 'home_bloc.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}
class HomeBackButtonSuccessState extends HomeState{}
class HomeBackButtonWarningState extends HomeState{}

class CheckRegistrationState extends HomeState{
  int? server;
  CheckRegistrationState(this.server);
}

class UpdateMovieThreeSuccess extends HomeState {
  List<Film> movieList;
  String category;
  UpdateMovieThreeSuccess(this.movieList,this.category);
}
class UpdateMovieTwoSuccess extends HomeState {
  List<Film> movieList;
  String category;
  UpdateMovieTwoSuccess(this.movieList,this.category);
}
class SearchMovieLoadingState extends HomeState{
}
class SearchMovieSuccessState extends HomeState{
  List<Film> movieList;
  SearchMovieSuccessState(this.movieList);
}
class LoadHomeDataSuccessState extends HomeState{
  List<SliderModel> sliderList;
  List<Film> cartoonList;
  List<Film> serialList;
  List<Film> filmList;
  List<Film> premierList;
  LoadHomeDataSuccessState(this.sliderList,this.filmList,this.cartoonList,this.serialList,this.premierList);
}
class ActionProfileSliderState extends HomeState{}
class ActionSliderRebuildState extends HomeState{}
class ActionSliderSearchState extends HomeState{}
class ActionSliderCategoryOneState extends HomeState{}
class ActionCategoryMovieOneState extends HomeState{}
class ActionProfileSearchState extends HomeState{}
class ActionMovieOneRowOneState extends HomeState{}
class ActionMovieTwoCategoryThreeState extends HomeState{}
class ActionMovieThreeCategoryThreeState extends HomeState{}
class ActionRowOneRowTwoState extends HomeState{}
class ActionCategoryTwoMovieTwoState extends HomeState{}
class ActionRowTwoCategoryTwoState extends HomeState{}
class ActionRowTwoLeftState extends HomeState{
  int index;
  ActionRowTwoLeftState(this.index);
}
class ActionRowTwoRightState extends HomeState{
  int index;
  ActionRowTwoRightState(this.index);
}
class ActionRowOneRightState extends HomeState{
  int index;
  ActionRowOneRightState(this.index);
}
class ActionRowOneLeftState extends HomeState{
  int index;
  ActionRowOneLeftState(this.index);
}
class ActionMovieOneRightState extends HomeState{
  int index;
  ActionMovieOneRightState(this.index);
}
class ActionMovieOneLeftState extends HomeState{
  int index;
  ActionMovieOneLeftState(this.index);
}

class ActionMovieTwoRightState extends HomeState{
  int index;
  ActionMovieTwoRightState(this.index);
}
class ActionMovieTwoLeftState extends HomeState{
  int index;
  ActionMovieTwoLeftState(this.index);
}
class ActionMovieThreeRightState extends HomeState{
  int index;
  ActionMovieThreeRightState(this.index);
}
class ActionMovieThreeLeftState extends HomeState{
  int index;
  ActionMovieThreeLeftState(this.index);
}
class SearchActionMovieRightState extends HomeState {
  int index;

  SearchActionMovieRightState(this.index);
}

class SearchActionMovieLeftState extends HomeState {
  int index;

  SearchActionMovieLeftState(this.index);
}

class SearchActionMovieUpState extends HomeState {
  int index;

  SearchActionMovieUpState(this.index);
}
class SearchActionMovieDownState extends HomeState {
  int index;

  SearchActionMovieDownState(this.index);
}