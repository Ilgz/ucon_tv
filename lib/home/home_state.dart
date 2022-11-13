part of 'home_bloc.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}
class UpdateMovieSuccess extends HomeState {
  List<Film> movieList;
  String category;
  UpdateMovieSuccess(this.movieList,this.category);

}
class SearchMovieLoadingState extends HomeState{
}
class SearchMovieSuccessState extends HomeState{
  List<Film> movieList;
  SearchMovieSuccessState(this.movieList);
}
class LoadHomeDataSuccessState extends HomeState{
  List<Slider> sliderList;
  List<Film> cartoonList;
  List<Film> serialList;
  List<Film> filmList;
  List<Film> premierList;
  LoadHomeDataSuccessState(this.sliderList,this.filmList,this.cartoonList,this.serialList,this.premierList);
}