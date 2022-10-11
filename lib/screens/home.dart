import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../home/home_bloc.dart';
import '../model/film.dart';
import '../utils/actionHandler.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int activeIndex = 0;
  int lastFilmIndex= 0;
  int lastPremierIndex = 0;
  List<ScrollController> scrollController =
      List.generate(2, (index) => ScrollController());
  FocusNode? sliderFocusNode;
  List<FocusNode>? premierFocusList;
  List<FocusNode>? filmFocusList;
  CarouselController carouselController = CarouselController();
  ScrollController pageController=ScrollController();
  @override
  void initState() {
    BlocProvider.of<HomeBloc>(context)..add(LoadHomeDataEvent());
    super.initState();
  }

  @override
  void dispose() {
    premierFocusList?.forEach((element) {
      element.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (sliderFocusNode == null) {
      sliderFocusNode = FocusNode();
      FocusScope.of(context).requestFocus(sliderFocusNode);
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
            controller: pageController,
            child: Column(
              children: [
                BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    if (state is LoadHomeDataSuccessState) {
                      return ClickRemoteActionWidget(
                        right: () {
                          setState(() {
                            carouselController.nextPage(
                                duration: Duration(milliseconds: 500));
                          });
                        },
                        left: () {
                          setState(() {
                            carouselController.previousPage(
                                duration: Duration(milliseconds: 500));
                          });
                        },
                        down: () {
                          if (premierFocusList != null) {
                            _changeFocus(
                                context, premierFocusList![lastPremierIndex]);
                          }
                        },
                        child: Focus(
                          focusNode: sliderFocusNode,
                          child: CarouselSlider.builder(
                            carouselController: carouselController,
                            options: CarouselOptions(
                              height: 250,
                              viewportFraction: 0.6,
                              //     aspectRatio: 2,
                              //  autoPlay: true,
                              enableInfiniteScroll: true,
                              onPageChanged: (index, reason) {
                                setState(() => activeIndex = index);
                              },
                            ),
                            itemCount: state.sliderList.length,
                            itemBuilder: (context, index, realIndex) {
                              final urlImage = state.sliderList[index].link;
                              return buildImage(urlImage, index);
                            },
                          ),
                        ),
                      );
                    }
                    return Container();
                  },
                ),
                BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    if (state is LoadHomeDataSuccessState) {
                      if (premierFocusList == null) {
                        premierFocusList = List.generate(
                            state.premierList.length, (index) => FocusNode());
                      }
                      ;
                      if (filmFocusList == null) {
                        filmFocusList = List.generate(
                            state.filmList.length, (index) => FocusNode());
                      }
                      return Column(children: [
                        ...buildSection("Премьеры", state.premierList, 0,
                            premierFocusList!),
                        ...buildSection(
                            "Фильмы", state.filmList, 1, filmFocusList!),
                        ...buildSection(
                            "Сериалы", state.filmList, 1, filmFocusList!)
                      ]);
                    }
                    return Container();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> buildSection(String sectionName, List<Film> listMovies,
      int sectionIndex, List<FocusNode> focusList) {
    return [
      SizedBox(height: 20),
      Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Text(
            sectionName.toUpperCase(),
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.cyan),
          )),
      Container(
          height: 220,
          child: ListView.builder(
            controller: scrollController[sectionIndex],
            scrollDirection: Axis.horizontal,
            itemCount: listMovies.length,
            //itemCount: state.filmList.length,
            itemBuilder: (context, index) {
              return buildMovieItem(
                  listMovies[index], index, sectionIndex, focusList);
              // return buildMovieItem(state.filmList[index],index);
            },
          ))
    ];
  }

  _changeFocus(BuildContext context, FocusNode node) {
    FocusScope.of(context).requestFocus(node);
    setState(() {});
  }

  Widget buildMovieItem(
      Film item, int index, int sectionIndex, List<FocusNode> focusList) {
    return ClickRemoteActionWidget(
      up: () {
        if (sectionIndex == 0) {
          _changeFocus(context, sliderFocusNode!);
          lastPremierIndex = index;
          pageController.animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
        } else if (sectionIndex == 1) {
          _changeFocus(context, premierFocusList![lastPremierIndex]);
          lastFilmIndex = index;
        }
      },
      right: () {
        if (focusList != null && (focusList!.length - 1) != index) {
          _changeFocus(context, focusList![index + 1]);
          print(sectionIndex);
          scrollController[sectionIndex].animateTo((index + 1) * 135,
              duration: Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn);
        }
      },
      down: () {
        if (sectionIndex == 0) {
          _changeFocus(context, filmFocusList![lastFilmIndex]);
          lastPremierIndex = index;
          pageController.animateTo(250, duration: Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
        }
      },
      left: () {
        if (focusList != null && index != 0) {
          _changeFocus(context, focusList[index - 1]);
          scrollController[sectionIndex].animateTo((index - 1) * 135,
              duration: Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn);
        }
      },
      child: Focus(
        focusNode: focusList?[index],
        child: Container(
          width: 135,
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
                    height: 160,
                    width: double.infinity,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      item.name,
                      style: TextStyle(color: Colors.white),
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

  Widget buildImage(String urlImage, int index) => Container(
        decoration: BoxDecoration(
            border: (index == activeIndex && sliderFocusNode!.hasFocus)
                ? Border.all(color: Colors.yellow, width: 2)
                : null),
        child: Image.network(
          urlImage,
          width: 500,
          fit: BoxFit.fill,
        ),
      );
}
