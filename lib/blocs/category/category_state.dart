part of 'category_bloc.dart';

abstract class CategoryState {}

class CategoryInitial extends CategoryState {}

class UpdateCategoryMovieLoading extends CategoryState {}

class UpdateCategoryMovieSuccess extends CategoryState {
  List<Film> movieList;
  int page;

  UpdateCategoryMovieSuccess(this.movieList, this.page);
}

class CategoryActionMovieRightState extends CategoryState {
  int index;

  CategoryActionMovieRightState(this.index);
}

class CategoryActionMovieLeftState extends CategoryState {
  int index;

  CategoryActionMovieLeftState(this.index);
}

class CategoryActionMovieUpState extends CategoryState {
  int index;

  CategoryActionMovieUpState(this.index);
}
class CategoryActionMovieDownState extends CategoryState {
  int index;

  CategoryActionMovieDownState(this.index);
}
