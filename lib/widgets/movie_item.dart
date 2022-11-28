import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_ucon/data/constants.dart';

import '../blocs/home/home_bloc.dart';
import '../models/film_model.dart';
import '../models/movie_model.dart';
import '../utils/actionHandler.dart';
import '../views/movie_play_page.dart';

class MovieItem extends StatelessWidget {
  MovieItem(
      {Key? key,
      required this.item,
      required this.index,
      required this.movieElement})
      : super(key: key);
  Film item;
  int index;
  MovieElement movieElement;

  @override
  Widget build(BuildContext context) {
    return ClickRemoteActionWidget(
      enter: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => MoviePlay(film: item)));
      },
      up: () {
        movieElement.lastElement = index;
        if(movieElement.sectionIndex==0){
          BlocProvider.of<HomeBloc>(context).add(ActionCategoryMovieOneEvent());
        }else if(movieElement.sectionIndex==1){
          BlocProvider.of<HomeBloc>(context).add(ActionCategoryTwoMovieTwoEvent());
        }else if(movieElement.sectionIndex==2){
          BlocProvider.of<HomeBloc>(context).add(ActionMovieThreeCategoryThreeEvent());
        }
        //changeFocus(context, movieElement.categoryFocus);
      },
      right: () {
        if (movieElement.elementsFocus != null && (movieElement.elementsFocus!.length - 1) != index) {
          if(movieElement.sectionIndex==0){
            BlocProvider.of<HomeBloc>(context).add(ActionMovieOneRightEvent(index));
          }else if(movieElement.sectionIndex==1){
            BlocProvider.of<HomeBloc>(context).add(ActionMovieTwoRightEvent(index));
          }else if(movieElement.sectionIndex==2){
            BlocProvider.of<HomeBloc>(context).add(ActionMovieThreeRightEvent(index));
          }
        }
        else{
          if(movieElement.sectionName!="Премьеры"){
            if(!HomeClass.isLoadingNewElements){
            if(movieElement.sectionIndex==1){
              BlocProvider.of<HomeBloc>(context).add(UpdateMovieTwoEvent(movieElement.sectionName));
            }else if(movieElement.sectionIndex==2){
              BlocProvider.of<HomeBloc>(context).add(UpdateMovieThreeEvent(movieElement.sectionName));
            }
               HomeClass.isLoadingNewElements=true;
            }
          }

        }
      },

      down: () {
        if (movieElement.sectionIndex == 0) {
          movieElement.lastElement = index;
          BlocProvider.of<HomeBloc>(context).add(ActionMovieOneRowOneEvent());
          HomeClass.pageController.animateTo(500,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.fastOutSlowIn);
        }
        else if (movieElement.sectionIndex == 1) {
          movieElement.lastElement = index;
          BlocProvider.of<HomeBloc>(context).add(ActionMovieTwoCategoryThreeEvent());
          HomeClass.pageController.animateTo(850,
              duration: const Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn);
        }
        // else if(widget.movieElement.sectionIndex==2){
        //   _changeFocus( HomeClass.movieElements[3].categoryFocus);
        //   widget.setState((){});
        //   widget.movieElement.lastElement = widget.index;
        //   widget.pageController.animateTo(1100,
        //       duration: const Duration(milliseconds: 500),
        //       curve: Curves.fastOutSlowIn);
        // }

      },
      left: () {
        if (movieElement.elementsFocus != null && index != 0) {
          if(movieElement.sectionIndex==0){
            BlocProvider.of<HomeBloc>(context).add(ActionMovieOneLeftEvent(index));
          }else if(movieElement.sectionIndex==1){
            BlocProvider.of<HomeBloc>(context).add(ActionMovieTwoLeftEvent(index));
          }else if(movieElement.sectionIndex==2){
            BlocProvider.of<HomeBloc>(context).add(ActionMovieThreeLeftEvent(index));
          }
        }
      },
      child: Focus(
        focusNode: movieElement.elementsFocus?[index],
        child: SizedBox(
          width: 135,
          child: Card(
            elevation: 5.0,
            clipBehavior: Clip.antiAlias,
            margin: (movieElement.elementsFocus != null &&
                    movieElement.elementsFocus![index].hasFocus)
                ? const EdgeInsets.symmetric(horizontal: 7, vertical: 3)
                : const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                  border: (movieElement.elementsFocus != null &&
                          movieElement.elementsFocus![index].hasFocus)
                      ? Border.all(color: Colors.yellow, width: 3)
                      : null),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const SizedBox(
                  //   height: 160,
                  //   width: double.infinity,
                  // ),
                  Image.network(
                    item.imageLink,
                    fit: BoxFit.fill,
                    height: 160,

                    width: double.infinity,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      item.name,
                      style: const TextStyle(color: Colors.white),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
