import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_ucon/screens/profile.dart';
import 'package:new_ucon/screens/search_home.dart';

import '../constants.dart';
import '../home/home_bloc.dart';
import '../model/film.dart';
import '../utils/actionHandler.dart';
import 'movie_play.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CarouselController carouselController = CarouselController();
  ScrollController pageController = ScrollController();
  int lastFilmIndex = 0;
  int lastPremierIndex = 0;
  int lastSerialIndex = 0;
  List<ScrollController> scrollController =
      List.generate(3, (index) => ScrollController());
  FocusNode? sliderFocusNode;
  List<FocusNode>? premierFocusList;
  List<FocusNode>? filmFocusList;
  List<FocusNode>? serialFocusList;
  int activeIndex = 0;

  @override
  void initState() {
    BlocProvider.of<HomeBloc>(context)..add(LoadHomeDataEvent());
    super.initState();
  }

  @override
  void dispose() {
    // premierFocusList?.forEach((element) {
    //   element.dispose();
    // });
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
          drawerEnableOpenDragGesture: false,
          appBar: AppBar(
              backgroundColor: const Color(0xff00001c),
              title: GestureDetector(onTap: () {}, child: const Text("Фильм")),
              actions: [
                ClickRemoteActionWidget(
                    right: () {
                      _changeFocus(context, FocusList.profileFocus);
                    },
                    enter: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SearchHome()));
                    },
                    down: () {
                      _changeFocus(context, sliderFocusNode!);
                      pageController.animateTo(0,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.fastOutSlowIn);
                    },
                    child: Focus(
                      focusNode: FocusList.searchFocus,
                      child: Icon(
                        Icons.search,
                        color: FocusList.searchFocus.hasFocus
                            ? Colors.orange
                            : Colors.white,
                      ),
                    )),
                SizedBox(width: 20,),
                ClickRemoteActionWidget(
                    left: () {
                      _changeFocus(context, FocusList.searchFocus);
                    },
                    enter: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Profile()));
                    },
                    down: () {
                      _changeFocus(context, sliderFocusNode!);
                      pageController.animateTo(0,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.fastOutSlowIn);
                    },
                    child: Focus(
                      focusNode: FocusList.profileFocus,
                      child: Icon(
                        Icons.person,
                        color: FocusList.profileFocus.hasFocus
                            ? Colors.orange
                            : Colors.white,
                      ),
                    ))
              ]),
          backgroundColor: Colors.transparent,
          body: buildPage(),
        ),
      ),
    );
  }

  Widget buildPage() {
    return SingleChildScrollView(
      controller: pageController,
      child: Column(
        children: [
          BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is LoadHomeDataSuccessState) {
                return ClickRemoteActionWidget(
                  enter: () {
                    if ((sliderFocusNode!.hasFocus)) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MoviePlay(
                                  film: Film(
                                      name: state.sliderList[activeIndex].name,
                                      imageLink: state
                                          .sliderList[activeIndex].intentImgUrl,
                                      siteLink: state.sliderList[activeIndex]
                                          .intentSiteLink))));
                    }
                  },
                  up: () {
                    _changeFocus(context, FocusList.profileFocus);
                  },
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
                      pageController.animateTo(270,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.fastOutSlowIn);
                      _changeFocus(
                          context, premierFocusList![lastPremierIndex]);
                    }
                  },
                  child: Focus(
                    focusNode: sliderFocusNode,
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: CarouselSlider.builder(
                        carouselController: carouselController,
                        options: CarouselOptions(
                          height: 250,
                          viewportFraction: 0.6,
                          enableInfiniteScroll: true,
                          onPageChanged: (index, reason) {
                            setState(() => activeIndex = index);
                          },
                        ),
                        itemCount: state.sliderList.length,
                        itemBuilder: (context, index, realIndex) {
                          final urlImage = state.sliderList[index].link;
                          return buildImage(
                              urlImage,
                              index,
                              state.sliderList[index].name,
                              state.sliderList[index].intentImgUrl,
                              state.sliderList[index].intentSiteLink);
                        },
                      ),
                    ),
                  ),
                );
              }
              return Container();
            },
          ),
          BlocConsumer<HomeBloc, HomeState>(
            listener: (context, state) {
              if (state is LoadHomeDataSuccessState) {
                premierFocusList ??= List.generate(
                    state.premierList.length, (index) => FocusNode());
                filmFocusList ??= List.generate(
                    state.filmList.length, (index) => FocusNode());
                serialFocusList ??= List.generate(
                    state.serialList.length, (index) => FocusNode());
                Repository.allElements.addAll(state.premierList);
                Repository.allElements.addAll(state.filmList);
                Repository.allElements.addAll(state.serialList);
              }
            },
            builder: (context, state) {
              if (state is LoadHomeDataSuccessState) {
                return Column(children: [
                  ...buildSection(
                      "Премьеры", state.premierList, 0, premierFocusList!),
                  ...buildSection("Фильмы", state.filmList, 1, filmFocusList!),
                  ...buildSection(
                      "Сериалы", state.serialList, 2, serialFocusList!)
                ]);
              }
              return Container();
            },
          ),
        ],
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
            itemBuilder: (context, index) {
              return buildMovieItem(
                  listMovies[index], index, sectionIndex, focusList);
            },
          ))
    ];
  }

  Widget buildMovieItem(
      Film item, int index, int sectionIndex, List<FocusNode> focusList) {
    return ClickRemoteActionWidget(
      enter: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => MoviePlay(film: item)));
      },
      up: () {
        if (sectionIndex == 0) {
          _changeFocus(context, sliderFocusNode!);
          lastPremierIndex = index;
          pageController.animateTo(0,
              duration: Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn);
        } else if (sectionIndex == 1) {
          _changeFocus(context, premierFocusList![lastPremierIndex]);
          lastFilmIndex = index;
          pageController.animateTo(270,
              duration: Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn);
        } else if (sectionIndex == 2) {
          _changeFocus(context, filmFocusList![lastFilmIndex]);
          lastSerialIndex = index;
          pageController.animateTo(440,
              duration: Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn);
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
          pageController.animateTo(440,
              duration: Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn);
        }
        if (sectionIndex == 1) {
          _changeFocus(context, serialFocusList![lastSerialIndex]);
          lastFilmIndex = index;
          pageController.animateTo(610,
              duration: Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn);
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

  Widget buildImage(
    String urlImage,
    int index,
    String name,
    String posterUrl,
    String siteLink,
  ) =>
      Container(
        decoration: BoxDecoration(
            border: (index == activeIndex && sliderFocusNode!.hasFocus)
                ? Border.all(color: Colors.yellow, width: 2)
                : Border.all(color: Colors.transparent, width: 2)),
        child: Stack(
          children: [
            Image.network(
              urlImage,
              width: 500,
              fit: BoxFit.fill,
            ),
            Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black,
                      ],
                    )),
                    child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          name,
                          style: TextStyle(
                              fontSize: 18, color: Colors.white.withOpacity(1)),
                        ))))
          ],
        ),
      );

  _changeFocus(BuildContext context, FocusNode node) {
    FocusScope.of(context).requestFocus(node);
    setState(() {});
  }
}
