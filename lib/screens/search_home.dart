import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_ucon/utils/actionHandler.dart';
import '../home/home_bloc.dart';
import '../model/film.dart';
import 'movie_play.dart';

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
 List<FocusNode>? allFocusList ;


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
                      allFocusList?.forEach((element) {
                        element.dispose();
                      });
                      allFocusList?.clear();
                      allFocusList = List.generate(state.movieList.length, (index) => FocusNode());
                      FocusScope.of(context).requestFocus(allFocusList?.first);
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
                      if(allFocusList!=null){
                        return GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 6, childAspectRatio: 120 / 200),
                          controller: listScrollController,
                          scrollDirection: Axis.vertical,
                          itemCount: state.movieList.length,
                          itemBuilder: (context, index) {
                            return buildMovieItem(
                                state.movieList[index], index, allFocusList!,state.movieList);
                          },
                        );
                      }
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
               _changeFocus(context, allFocusList?[lastElement]);
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
          _changeFocus(context, allFocusList?[0]);
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
  Widget buildMovieItem(Film item, int index, List<FocusNode> focusList,List<Film> movieList) {
    return ClickRemoteActionWidget(
      up: () {
        if (index < 6) {
          _changeFocus(context, _cancelButFocus);
          lastElement = index;
        } else {

          if (index < (movieList.length + 6)) {

            _changeFocus(context, focusList[index - 6]);
            int group = 1;
            while (true) {
              if ((index + 1) - (6 * group) <= 0) {
                break;
              } else {
                group++;
              }
            }
            group -= 2;
            listScrollController.animateTo(group * (200 + 30),
                duration: const Duration(milliseconds: 500),
                curve: Curves.fastOutSlowIn);
          }
        }
      },
      right: () {
        if (focusList != null && (focusList.length - 1) != index) {
          _changeFocus(context, focusList[index + 1]);
          if (((index + 1) % 6) == 0) {
            int group = 1;
            while (true) {
              if ((index + 1) - (6 * group) <= 0) {
                break;
              } else {
                group++;
              }
            }
            listScrollController.animateTo(group * (200 + 30),
                duration: const Duration(milliseconds: 500),
                curve: Curves.fastOutSlowIn);
          }
        }
      },
      down: () {
        if (index < (movieList.length - 6)) {
          _changeFocus(context, focusList[index + 6]);
          int group = 1;
          while (true) {
            if ((index + 1) - (6 * group) <= 0) {
              break;
            } else {
              group++;
            }
          }
          listScrollController.animateTo(group * (200 + 30),
              duration: const Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn);
        }
      },
      enter: (){
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => MoviePlay(film: item)));
      },
      left: () {
        if (focusList != null && index != 0) {
          _changeFocus(context, focusList[index - 1]);
          if (((index) % 6) == 0) {
            int group = 1;
            while (true) {
              if ((index + 1) - (6 * group) <= 0) {
                break;
              } else {
                group++;
              }
            }
            group -= 2;
            listScrollController.animateTo(group * (200 + 30),
                duration: const Duration(milliseconds: 500),
                curve: Curves.fastOutSlowIn);
          }
        }
      },
      child: Focus(
        focusNode: focusList?[index],
        child: Card(
          elevation: 5.0,
          clipBehavior: Clip.antiAlias,
          margin: (focusList != null && focusList![index].hasFocus)
              ? const EdgeInsets.symmetric(horizontal: 7, vertical: 3)
              : const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
                border: (focusList != null && focusList![index].hasFocus)
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
