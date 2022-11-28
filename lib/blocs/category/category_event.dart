part of 'category_bloc.dart';

abstract class CategoryEvent {}

class UpdateCategoryMovieEvent extends CategoryEvent {
  String category;
  int page;

  UpdateCategoryMovieEvent(this.category, this.page);
}

class CategoryActionMovieRightEvent extends CategoryEvent {
  int index;

  CategoryActionMovieRightEvent(this.index);
}

class CategoryActionMovieLeftEvent extends CategoryEvent {
  int index;

  CategoryActionMovieLeftEvent(this.index);
}

class CategoryActionMovieUpEvent extends CategoryEvent {
  int index;
  CategoryActionMovieUpEvent(this.index);
}
class CategoryActionMovieDownEvent extends CategoryEvent {
  int index;
  CategoryActionMovieDownEvent(this.index);
}
