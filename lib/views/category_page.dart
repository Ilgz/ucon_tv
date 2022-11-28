import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_ucon/blocs/category/category_bloc.dart';
import 'package:new_ucon/data/producers.dart';
import 'package:new_ucon/models/producer_model.dart';
import 'package:new_ucon/widgets/dialogs/category_dialog.dart';
import '../models/film_model.dart';
import '../utils/actionHandler.dart';
import 'movie_play_page.dart';

class CategoryPage extends StatefulWidget {
  String sectionName;

  CategoryPage({Key? key, required this.sectionName}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  int page = 1;
  ScrollController listScrollController = ScrollController();
  late List<Producer> producerList;
  List<FocusNode> focusList = [];
  List<FocusNode> producerFocusList = [];
  late Producer selectedProducer;
  List<Film> movieList = [];
  int lastElement = 0;
  bool loading = false;
  final FocusNode backButtonFocus = FocusNode();
  final FocusNode categoryButtonFocus = FocusNode();
  bool isFirst = true;
  @override
  Widget build(BuildContext context) {
    if (isFirst) {
      ProducerClass producerClass = ProducerClass(widget.sectionName);
      producerList = widget.sectionName != "Мультфильмы"
          ? producerClass.movieProducers()
          : producerClass.cartoonProducers();
      producerFocusList =
          List.generate(producerList.length, (index) => FocusNode());
      selectedProducer = producerList.first;
        BlocProvider.of<CategoryBloc>(context).add(UpdateCategoryMovieEvent(
            producerList.first.link, 1));
      isFirst = false;
    }

    return HandleRemoteActionsWidget(
        child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: Image.asset('assets/images/background_home.jpg').image,
                  fit: BoxFit.cover),
            ),
            child: Scaffold(
                backgroundColor: Colors.transparent,
                body: SingleChildScrollView(
                  controller: listScrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ClickRemoteActionWidget(
                              right: () {
                                _changeFocus(context, categoryButtonFocus);
                              },
                              enter: () {
                                Navigator.pop(context);
                              },
                              down: () {
                                _changeFocus(context, producerFocusList.first);
                              },
                              child: Focus(
                                  focusNode: backButtonFocus,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child:CircleAvatar(
                                        radius: 20,
                                        backgroundColor:
                                            backButtonFocus.hasFocus?Colors.orange.withOpacity(1):Colors.black.withOpacity(1),
                                        child: Icon(Icons.arrow_back,
                                            color: backButtonFocus.hasFocus
                                                ? Colors.black
                                                : Colors.white),

                                    ),
                                  ))),


                          const Expanded(flex:2,child: SizedBox()),
                          Expanded(flex:1,
                            child: ClickRemoteActionWidget(
                              left: () {
                                _changeFocus(context, backButtonFocus);
                              },
                              down: () {
                                _changeFocus(context, producerFocusList.first);
                              },
                              enter: () {
                                  showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (BuildContext context) =>
                                          CategoryDialog(
                                            callback: (producer) {
                                              page = 1;
                                              BlocProvider.of<CategoryBloc>(context)
                                                  .add(UpdateCategoryMovieEvent(
                                                      producer.link, page));
                                              selectedProducer = producer;
                                            },
                                            sectionName: widget.sectionName,
                                          ));
                              },
                              child: Focus(
                                focusNode: categoryButtonFocus,
                                child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                            border: categoryButtonFocus.hasFocus
                                                ? Border.all(color: Colors.yellow, width: 3)
                                                : Border.all(color: Colors.indigo, width: 3),
                                        color:  Colors.transparent.withOpacity(0.6)),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 100),
                                    child: const Text(
                                      "Категории",

                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 20,color: Colors.white),
                                    )),
                              ),
                            ),
                          ),

                        ],
                      ),
                      SizedBox(
                        height: 80,
                        child: ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          scrollDirection: Axis.horizontal,
                          itemCount: producerList.length,
                          itemBuilder: (context, index) {
                            return buildProducerCard(index);
                          },
                        ),
                      ),
                      BlocConsumer<CategoryBloc, CategoryState>(
                        buildWhen: (context, state) {
                          if (state is UpdateCategoryMovieSuccess ||
                              state is UpdateCategoryMovieLoading) {
                            return true;
                          } else {
                            return false;
                          }
                        },
                        listener: (context, state) {
                          if (state is UpdateCategoryMovieSuccess) {
                            loading = false;
                            if (state.page == 1) {
                              focusList.clear();
                              movieList.clear();
                            }
                            movieList.addAll(state.movieList);
                            int newElement = focusList.length;
                            focusList.addAll(List.generate(
                                state.movieList.length,
                                (index) => FocusNode()));
                            _changeFocus(context, focusList[newElement]);
                            int group = 1;
                            while (true) {
                              if ((newElement + 1) - (6 * group) <= 0) {
                                break;
                              } else {
                                group++;
                              }
                            }
                            --group;
                            listScrollController.animateTo(group * (230 + 30),
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.fastOutSlowIn);
                          }
                        },
                        builder: (context, state) {
                          if (state is UpdateCategoryMovieSuccess) {
                            return GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 6,
                                      childAspectRatio: 120 / 200),
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              primary: false,
                              scrollDirection: Axis.vertical,
                              itemCount: movieList.length,
                              itemBuilder: (context, index) {
                                return BlocConsumer<CategoryBloc, CategoryState>(
                                  buildWhen: (context,state){
                                    if(state is CategoryActionMovieRightState){
                                           if(state.index==index){
                                             return true;
                                           }
                                           if((state.index+1)==index){
                                             return true;
                                           }
                                    }
                                    else if(state is CategoryActionMovieLeftState){
                                      if(state.index==index){
                                        return true;
                                      }
                                      if((state.index-1)==index){
                                        return true;
                                      }
                                    }
                                    else if(state is CategoryActionMovieDownState){
                                      if(state.index==index){
                                        return true;
                                      }
                                      if((state.index+6)==index){
                                        return true;
                                      }
                                    }else if(state is CategoryActionMovieUpState){
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
    if (state is CategoryActionMovieRightState) {
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
    }else if(state is CategoryActionMovieLeftState){
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
    else if(state is CategoryActionMovieDownState){
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
          if (!loading) {
            ++page;
            BlocProvider.of<CategoryBloc>(context)
                .add(UpdateCategoryMovieEvent(selectedProducer.link, page));
            loading = true;
          }
      }
    }
    else if(state is CategoryActionMovieUpState){
      if (state.index < 6) {
        _changeFocus(context, producerFocusList.first);
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
                          return const Center(
                              child: CircularProgressIndicator(
                            color: Colors.white,
                          ));
                        },
                      ),
                    ],
                  ),
                ))));
  }

  Widget buildProducerCard(int index) {
    return ClickRemoteActionWidget(
      right: () {
        if (index != (producerFocusList.length - 1)) {
          _changeFocus(context, producerFocusList[index + 1]);
        }
      },
      up: () {
        _changeFocus(context, backButtonFocus);
      },
      enter: () {
          page = 1;
          BlocProvider.of<CategoryBloc>(context)
              .add(UpdateCategoryMovieEvent(producerList[index].link, page));
          selectedProducer = producerList[index];
      },
      left: () {
        if (index != 0) {
          _changeFocus(context, producerFocusList[index - 1]);
        }
      },
      down: () {
        _changeFocus(context, focusList.first);
      },
      child: Focus(
        focusNode: producerFocusList[index],
        child: Card(
          elevation: 5.0,
          clipBehavior: Clip.antiAlias,
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: producerList[index].name==selectedProducer.name
                    ? Colors.orange
                    :Colors.transparent,
                border: producerFocusList[index].hasFocus
                    ? Border.all(color: Colors.yellow, width: 3)
                    : Border.all(color: Colors.indigo, width: 3)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 30,
                    width: 120,
                    child: SvgPicture.asset(
                      "assets/images/" + producerList[index].imageName + ".svg",
                      fit: BoxFit.scaleDown,
                      height: 30,
                      width: 120,
                      color:  Colors.white
                      ,
                      // height: 30,
                      // width: 30,
                    ),
                  ),
                ),
                if (producerList[index].imageName == "newbie") ...[
                  const Text(
                    "Новинки",
                    style: TextStyle(color: Colors.white),
                  )
                ] else if (producerList[index].imageName == "others") ...[
                  const Text(
                    "Другие",
                    style: TextStyle(color: Colors.white),
                  )
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }

  _changeFocus(BuildContext context, FocusNode? node) {
    FocusScope.of(context).requestFocus(node);
    setState(() {});
  }

  Widget buildMovieItem(
      Film item, int index, List<FocusNode> focusList, List<Film> movieList) {
    return ClickRemoteActionWidget(
      up: () {
       BlocProvider.of<CategoryBloc>(context).add(CategoryActionMovieUpEvent(index));
      },
      right: () {
       BlocProvider.of<CategoryBloc>(context).add(CategoryActionMovieRightEvent(index));
      },
      down: () {
        BlocProvider.of<CategoryBloc>(context).add(CategoryActionMovieDownEvent(index));
      },
      enter: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => MoviePlay(film: item)));
      },
      left: () {
        BlocProvider.of<CategoryBloc>(context).add(CategoryActionMovieLeftEvent(index));
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
