import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/home/home_bloc.dart';
import '../data/constants.dart';
import '../models/movie_model.dart';
import '../views/category_page.dart';
import '../utils/actionHandler.dart';
import 'movie_item.dart';

class ListViewMovie extends StatelessWidget {
  ListViewMovie({Key? key, required this.movieElement}) : super(key: key);
  MovieElement movieElement;
  static bool categoryOneWillRequest = true;
  static bool categoryTwoWillRequest = true;
  static bool categoryThreeWillRequest = true;
  static bool movieOneWillRequest = true;
  static bool movieTwoWillRequest = true;
  static bool movieThreeWillRequest = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        ClickRemoteActionWidget(
          enter: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        CategoryPage(
                          sectionName: movieElement.sectionName,
                        )));
          },
          up: () {
            if (movieElement.sectionIndex == 0) {
              BlocProvider.of<HomeBloc>(context).add(ActionSliderCategoryOneEvent());
              HomeClass.pageController.animateTo(0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.fastOutSlowIn);
            }
            else if (movieElement.sectionIndex == 1) {

              BlocProvider.of<HomeBloc>(context).add(ActionRowTwoCategoryTwoEvent());
              HomeClass.pageController.animateTo(500,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.fastOutSlowIn);
            }
            else if (movieElement.sectionIndex == 2) {
              BlocProvider.of<HomeBloc>(context).add(ActionMovieTwoCategoryThreeEvent());
              HomeClass.pageController.animateTo(610,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.fastOutSlowIn);
            }
          },
          down: () {
            if(movieElement.sectionIndex==0){
              BlocProvider.of<HomeBloc>(context).add(ActionCategoryMovieOneEvent());
            }else if(movieElement.sectionIndex==1){
             BlocProvider.of<HomeBloc>(context).add(ActionCategoryTwoMovieTwoEvent());
            }else if(movieElement.sectionIndex==2){
              BlocProvider.of<HomeBloc>(context).add(ActionMovieThreeCategoryThreeEvent());
            }
          },
          child: Focus(
            focusNode: movieElement.categoryFocus,
            child: BlocConsumer<HomeBloc, HomeState>(
              listener: (context, state) {
                if(movieElement.sectionIndex==0){
                  if (state is ActionSliderCategoryOneState||state is ActionCategoryMovieOneState) {
                    if (!categoryOneWillRequest) {
                      categoryOneWillRequest = true;
                    } else {
                      FocusScope.of(context).requestFocus(
                          movieElement.categoryFocus);
                      categoryOneWillRequest = false;
                    }
                  }
                }else if(movieElement.sectionIndex==1){
                  if(state is ActionRowTwoCategoryTwoState||state is ActionCategoryTwoMovieTwoState){
                    if (!categoryTwoWillRequest) {
                      categoryTwoWillRequest = true;
                    } else {
                      FocusScope.of(context).requestFocus(
                          movieElement.categoryFocus);
                      categoryTwoWillRequest = false;
                    }
                  }
                }
                else if(movieElement.sectionIndex==2){
                  if (state is ActionMovieTwoCategoryThreeState||state is ActionMovieThreeCategoryThreeState) {
                    if (!categoryThreeWillRequest) {
                      categoryThreeWillRequest = true;
                    } else {
                      FocusScope.of(context).requestFocus(
                          movieElement.categoryFocus);
                      categoryThreeWillRequest = false;
                    }
                  }
                }

              },
              buildWhen: (context, state) {
    if(movieElement.sectionIndex==0) {
      if (state is ActionSliderCategoryOneState ||
          state is ActionCategoryMovieOneState) {
        return true;
      } else {
        return false;
      }
    }else if(movieElement.sectionIndex==1){
      if(state is ActionRowTwoCategoryTwoState||state is ActionCategoryTwoMovieTwoState){
        return true;
      }else{
        return false;
      }
    }
    else if(movieElement.sectionIndex==2){
      if(state is ActionMovieTwoCategoryThreeState||state is ActionMovieThreeCategoryThreeState){
        return true;
      }
    }
      return false;
              },
              builder: (context, state) {
                return Container(
                    padding: EdgeInsets.all(2),
                    color: movieElement.categoryFocus.hasFocus?Colors.yellow:Colors.transparent,
                    margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Text(
                      movieElement.sectionName.toUpperCase(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: movieElement.categoryFocus.hasFocus?16:16,
                          color:  movieElement.categoryFocus.hasFocus?Colors.black:Colors.yellow
                              ),
                    ));
              },
            ),
          ),
        ),
        SizedBox(
          height: 220,
          child: BlocConsumer<HomeBloc, HomeState>(
            buildWhen: (context,state){
              // if(state is UpdateMovieTwoSuccess){
              //   return true;
              // }else{
                return false;
             // }
            },
  listener: (context, state) {
    if(state is UpdateMovieTwoSuccess){
      if(HomeClass.isLoadingNewElements==true){
      HomeClass.movieElements[1].elements.addAll(state.movieList);
      int newElement = HomeClass.movieElements[1].elementsFocus!.length;
      HomeClass.movieElements[1].elementsFocus?.addAll(List.generate(state.movieList.length, (index) => FocusNode()));
      FocusScope.of(context).requestFocus(
          HomeClass.movieElements[1].elementsFocus![newElement]);
      HomeClass.movieElements[1].scrollController.animateTo(newElement * 135,
          duration: const Duration(milliseconds: 300),
          curve: Curves.fastOutSlowIn);
      HomeClass.isLoadingNewElements=false;
      }
    }else if(state is UpdateMovieThreeSuccess){
      if(HomeClass.isLoadingNewElements==true){
        HomeClass.movieElements[2].elements.addAll(state.movieList);
        int newElement = HomeClass.movieElements[1].elementsFocus!.length;
        HomeClass.movieElements[2].elementsFocus?.addAll(List.generate(state.movieList.length, (index) => FocusNode()));
        FocusScope.of(context).requestFocus(
            HomeClass.movieElements[2].elementsFocus![newElement]);
        HomeClass.movieElements[2].scrollController.animateTo(newElement * 135,
            duration: const Duration(milliseconds: 300),
            curve: Curves.fastOutSlowIn);
        HomeClass.isLoadingNewElements=false;
      }
    }
  },
  builder: (context, state) {
    return ListView.builder(
            shrinkWrap: true,
            primary: false,
            controller: movieElement.scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: movieElement.elements.length,
            itemBuilder: (context, index) {
              return BlocConsumer<HomeBloc, HomeState>(
                listener: (context, state) {
                  if(movieElement.sectionIndex==0){
                  if (state is ActionCategoryMovieOneState||state is ActionMovieOneRowOneState) {
                    if(index==movieElement.lastElement){
                      movieOneWillRequest=requestOrRebuildListener(context, movieOneWillRequest, index);
                    }
                  }
                  else if (state is ActionMovieOneRightState) {
                       movingActionListener(context,state.index, index,1);
                  }
                  else if (state is ActionMovieOneLeftState) {
                      movingActionListener(context,state.index,index,-1);
                  }
                }else if(movieElement.sectionIndex==1){
                  if (state is ActionCategoryTwoMovieTwoState||state is ActionMovieTwoCategoryThreeState) {
                  if(index==movieElement.lastElement){
                  movieTwoWillRequest=requestOrRebuildListener(context, movieTwoWillRequest, index);
                  }
                  }else if(state is ActionMovieTwoRightState){
                    movingActionListener(context,state.index, index,1);
                  }else if(state is ActionMovieTwoLeftState){
                    movingActionListener(context,state.index, index,-1);

                  }
                  }else if(movieElement.sectionIndex==2){
                    if(state is ActionMovieThreeCategoryThreeState){
                      if(index==movieElement.lastElement){
                        movieThreeWillRequest=requestOrRebuildListener(context, movieThreeWillRequest, index);
                      }
                    }else if(state is ActionMovieThreeRightState){
                      movingActionListener(context,state.index, index,1);
                    }else if(state is ActionMovieThreeLeftState){
                      movingActionListener(context,state.index, index,-1);
                    }
                  }
                }
                ,
                buildWhen: (context,state) {
                  if (movieElement.sectionIndex == 0) {
                    if (state is ActionCategoryMovieOneState ||
                        state is ActionMovieOneRowOneState) {
                      return requestOrRebuildBuildWhen(index);
                    }
                    else if (state is ActionMovieOneRightState) {
                      return movingActionBuildWhen(state.index, index, 1);
                    }
                    else if (state is ActionMovieOneLeftState) {
                      return movingActionBuildWhen(state.index, index, -1);
                    }
                  }else if(movieElement.sectionIndex==1){
                    if(state is ActionCategoryTwoMovieTwoState||state is ActionMovieTwoCategoryThreeState){
                      return requestOrRebuildBuildWhen(index);
                    }
                    else if(state is ActionMovieTwoRightState ){
                      return movingActionBuildWhen(state.index, index, 1);
                    }
                    else if(state is ActionMovieTwoLeftState ){
                      return movingActionBuildWhen(state.index, index, -1);
                    }
                  }
                  else if(movieElement.sectionIndex==2){
                    if(state is ActionMovieThreeCategoryThreeState){
                      return requestOrRebuildBuildWhen(index);
                    }else if(state is ActionMovieThreeRightState){
                      return movingActionBuildWhen(state.index, index, 1);
                    }else if(state is ActionMovieThreeLeftState){
                      return movingActionBuildWhen(state.index, index, -1);
                    }
                  }

                    return false;
                }
                ,
                builder: (context, state) {
                  return MovieItem(
                    item: movieElement.elements[index],
                    index: index,
                    movieElement: movieElement,
                  );
                },
              );
            },
          );
  },
),
        )
      ],
    );
  }
  void movingActionListener(BuildContext context,int stateIndex,int index,int side){
    if(stateIndex==index){
    FocusScope.of(context).requestFocus(
        movieElement.elementsFocus![index+side]);
    movieElement.scrollController.animateTo((index+side) * 135,
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn);
    }
  }
  bool movingActionBuildWhen(int stateIndex,int index,int side){
    if (index == stateIndex) {
      return true;
    } else if (index == (stateIndex + side)) {
      return true;
    } else {
      return false;
    }

  }
  bool requestOrRebuildListener(BuildContext context,bool willRequest,int index){
    if (!willRequest) {
      return true;
    } else {
      FocusScope.of(context).requestFocus(
          movieElement.elementsFocus![index]);
      return false;
    }
  }
  bool requestOrRebuildBuildWhen(int index){
    if (index == movieElement.lastElement) {
      return true;
    } else {
      return false;
    }
  }
}
