part of 'home_bloc.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}
class LoadHomeDataSuccessState extends HomeState{
  List<Slider> sliderList;
  List<Film> premierList;
  List<Film> filmList;
  LoadHomeDataSuccessState(this.sliderList,this.filmList,this.premierList);
}