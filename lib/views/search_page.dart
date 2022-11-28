import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_ucon/utils/actionHandler.dart';
import '../blocs/home/home_bloc.dart';
import '../models/film_model.dart';
import 'movie_play_page.dart';

class SearchHome extends StatefulWidget {
  const SearchHome({Key? key}) : super(key: key);

  @override
  State<SearchHome> createState() => _SearchHomeState();
}

class _SearchHomeState extends State<SearchHome> {
  final FocusNode _cancelButFocus = FocusNode();
  final FocusNode _searchBarFocus = FocusNode();
  ScrollController listScrollController = ScrollController();
  int lastElement = 0;
 List<FocusNode> focusList=[];
 List<Film> movieList=[];


  @override
  Widget build(BuildContext context) {
    return HandleRemoteActionsWidget(
        child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: Image
                      .asset('assets/images/background_home.jpg')
                      .image,
                  fit: BoxFit.cover),
            ),
            child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: buildAppBar(context),
                body: BlocConsumer<HomeBloc, HomeState>(
                  listener: (context,state){
                    if(state is SearchMovieSuccessState){
                      movieList=state.movieList;
                      for (var element in focusList) {
                        element.dispose();
                      }
                      focusList.clear();
                      focusList = List.generate(state.movieList.length, (index) => FocusNode());
                      FocusScope.of(context).requestFocus(focusList.first);
                      setState(() {
                      });
                    }
                  },
                  buildWhen: (context,state){
                    if(state is SearchMovieSuccessState||state is SearchMovieLoadingState){
                      return true;
                    }else{
                      return false;
                    }
                  },
                  builder: (context, state) {

                    if(state is SearchMovieSuccessState){
                      return GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 6, childAspectRatio: 120 / 200),
                        controller: listScrollController,
                        scrollDirection: Axis.vertical,
                        itemCount: state.movieList.length,
                        itemBuilder: (context, index) {
                          return BlocConsumer<HomeBloc, HomeState>(
                            buildWhen: (context,state){
                              if(state is SearchActionMovieRightState){
                                if(state.index==index){
                                  return true;
                                }
                                if((state.index+1)==index){
                                  return true;
                                }
                              }
                              else if(state is SearchActionMovieLeftState){
                                if(state.index==index){
                                  return true;
                                }
                                if((state.index-1)==index){
                                  return true;
                                }
                              }
                              else if(state is SearchActionMovieDownState){
                                if(state.index==index){
                                  return true;
                                }
                                if((state.index+6)==index){
                                  return true;
                                }
                              }else if(state is SearchActionMovieUpState){
                                if(state.index==index){
                                  return true;
                                }
                                if((state.index-6)==index){
                                  return true;
                                }
                              }
                              return false;

                            },
                            listener: (context, state) {
                              if (state is SearchActionMovieRightState) {
                                if ((focusList.length - 1) != state.index) {
                                  FocusScope.of(context).requestFocus(
                                      focusList[state.index+1]);
                                  if (((state.index + 1) % 6) == 0) {
                                    int group = 1;
                                    while (true) {
                                      if ((state.index + 1) - (6 * group) <= 0) {
                                        break;
                                      } else {
                                        group++;
                                      }
                                    }
                                    listScrollController.animateTo(group * (230 + 30),
                                        duration: const Duration(milliseconds: 500),
                                        curve: Curves.fastOutSlowIn);
                                  }
                                }
                              }else if(state is SearchActionMovieLeftState){
                                if (state.index != 0) {
                                  FocusScope.of(context).requestFocus(
                                      focusList[state.index-1]);
                                  if (((state.index ) % 6) == 0) {
                                    int group = 1;
                                    while (true) {
                                      if ((state.index  + 1) - (6 * group) <= 0) {
                                        break;
                                      } else {
                                        group++;
                                      }
                                    }
                                    group -= 2;
                                    listScrollController.animateTo(group * (230 + 30),
                                        duration: const Duration(milliseconds: 500),
                                        curve: Curves.fastOutSlowIn);
                                  }
                                }
                              }
                              else if(state is SearchActionMovieDownState){
                                if (state.index < (movieList.length - 6)) {
                                  FocusScope.of(context).requestFocus(
                                      focusList[state.index+6]);
                                  int group = 1;
                                  while (true) {
                                    if ((state.index + 1) - (6 * group) <= 0) {
                                      break;
                                    } else {
                                      group++;
                                    }
                                  }
                                  listScrollController.animateTo(group * (230 + 30),
                                      duration: const Duration(milliseconds: 500),
                                      curve: Curves.fastOutSlowIn);
                                } else {
                                  // if (!loading) {
                                  //   ++page;
                                  //   BlocProvider.of<CategoryBloc>(context)
                                  //       .add(UpdateCategoryMovieEvent(selectedProducer.link, page));
                                  //   loading = true;
                                  // }
                                }
                              }
                              else if(state is SearchActionMovieUpState){
                                if (state.index < 6) {
                                  _changeFocus(context, _cancelButFocus);
                                  lastElement = index;
                                } else {
                                  if (state.index < (movieList.length + 6)) {
                                    FocusScope.of(context).requestFocus(focusList[state.index - 6]);
                                    int group = 1;
                                    while (true) {
                                      if ((state.index + 1) - (6 * group) <= 0) {
                                        break;
                                      } else {
                                        group++;
                                      }
                                    }
                                    group -= 2;
                                    listScrollController.animateTo(group * (230 + 30),
                                        duration: const Duration(milliseconds: 500),
                                        curve: Curves.fastOutSlowIn);
                                  }
                                }
                              }
                            },
                            builder: (context, state) {
                              return buildMovieItem(movieList[index], index,
                                  focusList, movieList);
                            },
                          );
                        },
                      );
                    }
                    if(state is SearchMovieLoadingState){
                     return const Center(child: Padding(
                        padding: EdgeInsets.only(bottom: 48.0),
                        child: CircularProgressIndicator(color: Colors.white,),
                      ));
                    }
                    return const Center(child: Padding(
                      padding: EdgeInsets.only(bottom: 48.0),
                      child: Text("Введите текст для поиска.",style: TextStyle(fontSize: 24,color: Colors.white),),
                    ));

                  },
                ))));
  }

  PreferredSizeWidget buildAppBar(BuildContext context) {
    return AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xff00001c),
        title: searchBar(),
        actions: [
          ClickRemoteActionWidget(
              left: () {
                _changeFocus(context, _searchBarFocus);
              },
              enter: () {
                Navigator.pop(context);
              },
              down: () {
               _changeFocus(context, focusList[lastElement]);
              },
              child: Focus(
                focusNode: _cancelButFocus,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(
                    Icons.cancel_outlined,
                    color: _cancelButFocus.hasFocus ? Colors.yellow : null,
                  ),
                ),
              ))
        ]);
  }
  Widget searchBar() {
    return ClickRemoteActionWidget(
        down: () {
          _changeFocus(context, focusList[0]);
        },
        right: (){
          _changeFocus(context, _cancelButFocus);
        },
        child: TextField(
            focusNode: _searchBarFocus,

            onSubmitted: (value) {
              BlocProvider.of<HomeBloc>(context).add(SearchMovieEvent(value));
            },
            decoration: const InputDecoration(
                hintText: "Поиск...",
                hintStyle: TextStyle(fontSize: 16, color: Colors.grey)),
            autofocus: true,
            style: const TextStyle(fontSize: 16, color: Colors.white)));
  }
  _changeFocus(BuildContext context, FocusNode? node) {
    FocusScope.of(context).requestFocus(node);
    setState(() {});
  }
  Widget buildMovieItem(
      Film item, int index, List<FocusNode> focusList, List<Film> movieList) {
    return ClickRemoteActionWidget(
      up: () {
        BlocProvider.of<HomeBloc>(context).add(SearchActionMovieUpEvent(index));
      },
      right: () {
        BlocProvider.of<HomeBloc>(context).add(SearchActionMovieRightEvent(index));
      },
      down: () {
        BlocProvider.of<HomeBloc>(context).add(SearchActionMovieDownEvent(index));
      },
      enter: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => MoviePlay(film: item)));
      },
      left: () {
        BlocProvider.of<HomeBloc>(context).add(SearchActionMovieLeftEvent(index));
      },
      child: Focus(
        focusNode: focusList[index],
        child: Card(
          elevation: 5.0,
          clipBehavior: Clip.antiAlias,
          margin: (focusList[index].hasFocus)
              ? const EdgeInsets.symmetric(horizontal: 7, vertical: 3)
              : const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
                border: (focusList[index].hasFocus)
                    ? Border.all(color: Colors.yellow, width: 3)
                    : null),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  item.imageLink,
                  fit: BoxFit.fill,
                  height: 190,
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
    );
  }
}
