part of 'home_bloc.dart';

abstract class HomeEvent {}
class LoadHomeDataEvent extends HomeEvent{}
class UpdateMovieEvent extends HomeEvent{
  String category;
  UpdateMovieEvent(this.category);
}