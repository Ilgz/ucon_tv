import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_ucon/channels.dart';
import 'package:new_ucon/model/movie_element.dart';
import 'package:new_ucon/screens/category.dart';
import 'package:new_ucon/screens/profile.dart';
import 'package:new_ucon/screens/search_home.dart';
import 'package:new_ucon/widgets/slider.dart';

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
  ScrollController pageController = ScrollController();
  late List<FocusNode> firstRowFocus,secondRowFocus;
  int lastElement=0;
  ScrollController channelScrollController=ScrollController();
  bool loading=false;
  bool isFirst=true;
  @override
  void initState() {
    BlocProvider.of<HomeBloc>(context).add(LoadHomeDataEvent());
    firstRowFocus=List.generate(getDoubleChannels()[0].length, (index) => FocusNode());
    secondRowFocus=List.generate(getDoubleChannels()[1].length, (index) => FocusNode());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isFirst) {
      FocusScope.of(context).requestFocus(HomeClass.sliderFocusNode);
      isFirst=false;
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
              title: const Text("Фильм"),
              actions: [
                ClickRemoteActionWidget(
                    right: () {
                      changeFocus(context, HomeClass.profileFocus);
                    },
                    enter: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SearchHome()));
                    },
                    down: () {
                      changeFocus(context, HomeClass.sliderFocusNode!);
                    },
                    child: Focus(
                      focusNode: HomeClass.searchFocus,
                      child: Icon(
                        Icons.search,
                        color: HomeClass.searchFocus.hasFocus
                            ? Colors.orange
                            : Colors.white,
                      ),
                    )),
                SizedBox(width: 20,),
                ClickRemoteActionWidget(
                    left: () {
                      changeFocus(context, HomeClass.searchFocus);
                    },
                    enter: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Profile()));
                    },
                    down: () {
                      changeFocus(context, HomeClass.sliderFocusNode!);
                      pageController.animateTo(0,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.fastOutSlowIn);
                    },
                    child: Focus(
                      focusNode: HomeClass.profileFocus,
                      child: Icon(
                        Icons.person,
                        color: HomeClass.profileFocus.hasFocus
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
      child: BlocConsumer<HomeBloc, HomeState>(
        buildWhen: (context,state){
          if(state is LoadHomeDataSuccessState){
            print("reBuildState");
            return true;
          }else{
            return false;
          }
        },
        listener: (context, state) {
          if (state is LoadHomeDataSuccessState) {
            HomeClass.movieElements.forEach((element) {
              if(element.sectionName=="Фильмы"){
                element.elements=state.filmList;
                element.elementsFocus ??= List.generate(
                    state.filmList.length, (index) => FocusNode());
              }
              else if(element.sectionName=="Сериалы"){
                element.elements=state.serialList;
                element.elementsFocus ??= List.generate(
                    state.serialList.length, (index) => FocusNode());
              }
              else if(element.sectionName=="Премьеры"){
                element.elements=state.premierList;
                element.elementsFocus ??= List.generate(
                    state.premierList.length, (index) => FocusNode());
              }
              else if(element.sectionName=="Мультфильмы"){
                element.elements=state.cartoonList;
                element.elementsFocus ??= List.generate(
                    state.cartoonList.length, (index) => FocusNode());
              }
            });
          }
          if(state is UpdateMovieSuccess){
            loading=false;
            for (var element in HomeClass.movieElements) {
              if(element.sectionName==state.category){
                updateMovieCollection(state.movieList, element.elements, element.elementsFocus!, element.scrollController);
              }
            }
          }
        },
        builder: (context, state) {
          if (state is LoadHomeDataSuccessState) {
            return Column(children: [
                MySlider(state: state, pageController: pageController,setStateFunction: (){
                  setState(() {});
                },mainContext: context,),

              buildSection(HomeClass.movieElements[0]),
            buildChannelSection(),
              buildSection(HomeClass.movieElements[1]),
              buildSection(HomeClass.movieElements[2]),
              buildSection(HomeClass.movieElements[3]),
            ]);
          }
          return Container();
        },
      ),
    );
  }


  Widget buildChannelSection(){
      return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return   Column(
              children: [
                SizedBox(height: 20),
                Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Text(
                      "Каналы",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.cyan),
                    )),
                Container(
                  height: 100,
                  child:
                  ListView.builder(
                    controller: channelScrollController,
                    shrinkWrap: true,
                    primary: false,

                    scrollDirection: Axis.horizontal,
                    itemCount: getDoubleChannels()[0].length,
                    itemBuilder: (context, index) {
                      return buildChannelItem(
                          getDoubleChannels()[0][index], index,
                          firstRowFocus[index], 0,setState);
                    },
                  ),
                ),
                Container(
                  height: 100,
                  child:
                  ListView.builder(
                    controller: channelScrollController,
                    shrinkWrap: true,
                    primary: false,
                    scrollDirection: Axis.horizontal,
                    itemCount: getDoubleChannels()[1].length,
                    itemBuilder: (context, index) {
                      return buildChannelItem(
                          getDoubleChannels()[1][index], index,
                          secondRowFocus[index], 1,setState);
                    },
                  ),
                )
              ],
            );
          }
      );

  }
  Widget buildChannelItem(Channel channel,int index,FocusNode focusNode,int row,StateSetter setState){
    _changeFocus(FocusNode focusNode) {
      setState(() {
        FocusScope.of(this.context).requestFocus(focusNode);
      });
    }
    return ClickRemoteActionWidget(
          enter: () {
      },
      up: () {
        if(row==1){
          _changeFocus( firstRowFocus[index]);
        }else{
          if (HomeClass.movieElements[0].elementsFocus != null) {
            lastElement=index;
            pageController.animateTo(270,
                duration: Duration(milliseconds: 500),
                curve: Curves.fastOutSlowIn);
            changeFocus(context,
                 HomeClass.movieElements[0].elementsFocus![HomeClass.movieElements[0].lastElement]);
          }
        }
      },
      right: () {
            if(row==0){
              if ((firstRowFocus.length - 1) != index) {
                _changeFocus(firstRowFocus[index + 1]);
                channelScrollController.animateTo((index + 1) * 160,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.fastOutSlowIn);
              }
            }else{
              if ((secondRowFocus.length - 1) != index) {
                _changeFocus( secondRowFocus[index + 1]);
                channelScrollController.animateTo((index + 1) * 160,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.fastOutSlowIn);
              }
            }


      },
      down: () {
          if(row==0){
            _changeFocus( secondRowFocus[index]);
          }else{
            changeFocus(context,HomeClass.movieElements[1].categoryFocus);
            lastElement=index;
            pageController.animateTo(610,
                duration: Duration(milliseconds: 500),
                curve: Curves.fastOutSlowIn);
          }
      },
      left: () {
          if (index != 0) {
            if(row==0){
              _changeFocus( firstRowFocus[index - 1]);
            }else{
              _changeFocus(secondRowFocus[index - 1]);

            }
            channelScrollController.animateTo((index - 1) * 160,
                duration: Duration(milliseconds: 500),
                curve: Curves.fastOutSlowIn);
          }

      },
      child: Focus(
      focusNode: focusNode,
      child: Container(
      width: 160,
      child: Card(
      elevation: 5.0,
      clipBehavior: Clip.antiAlias,
      margin: focusNode.hasFocus
      ? const EdgeInsets.symmetric(horizontal: 7, vertical: 3)
          : const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      color: Colors.transparent,
      child: Container(
      decoration: BoxDecoration(
      border: focusNode.hasFocus
      ? Border.all(color: Colors.yellow, width: 3)
          : null),
      child:
        Image.network(
        channel.imageLink,
        fit: BoxFit.fill,
          height: double.infinity,
          width: double.infinity,
      ),
      ),
      ),
      ),
      ),
      );

  }
  Widget  buildSection(MovieElement movieElement) {
      return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              children: [
                SizedBox(height: 20),

                ClickRemoteActionWidget(
                  enter: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>CategoryPage(sectionName: movieElement.sectionName,)));
                  },
                  up: (){
                    if (movieElement.sectionIndex == 0) {
                      changeFocus(context, HomeClass.sliderFocusNode);
                      pageController.animateTo(0,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.fastOutSlowIn);
                    } else if (movieElement.sectionIndex  == 1) {
                      changeFocus(context, secondRowFocus[lastElement]);
                      pageController.animateTo(500,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.fastOutSlowIn);
                    } else if (movieElement.sectionIndex == 2) {
                      changeFocus(context, HomeClass.movieElements[1].elementsFocus![HomeClass.movieElements[1].lastElement]);
                      pageController.animateTo(610,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.fastOutSlowIn);

                    }
                    else if (movieElement.sectionIndex == 3) {
                      changeFocus(context, HomeClass.movieElements[2].elementsFocus![HomeClass.movieElements[2].lastElement]);
                      pageController.animateTo(850,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.fastOutSlowIn);
                    }
                  },
                  down: (){
                    changeFocus(context, movieElement.elementsFocus![movieElement.lastElement]);
                  },
                  child: Focus(
                    focusNode: movieElement.categoryFocus,
                    child: Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        child: Text(
                          movieElement.sectionName.toUpperCase(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: movieElement.categoryFocus.hasFocus?Colors.yellow:Colors.cyan),
                        )),
                  ),
                ),
                Container(
                  height: 220,
                  child:
                  ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    controller: movieElement.scrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: movieElement.elements.length,
                    itemBuilder: (context, index) {
                      return buildMovieItem(
                          movieElement.elements[index], index, movieElement,setState);
                    },
                  ),
                )
              ],
            );
          } );
  }

  Widget buildMovieItem(
      Film item, int index, MovieElement movieElement,StateSetter setState) {
    _changeFocus(FocusNode focusNode) {
      setState(() {
        FocusScope.of(this.context).requestFocus(focusNode);
      });
    }
    return ClickRemoteActionWidget(
      enter: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => MoviePlay(film: item)));
      },
      up: () {

         movieElement.lastElement = index;
         changeFocus(context, movieElement.categoryFocus);

      },
      right: () {
        if (movieElement.elementsFocus != null && (movieElement.elementsFocus!.length - 1) != index) {
          _changeFocus(movieElement.elementsFocus![index + 1]);
          movieElement.scrollController.animateTo((index + 1) * 135,
              duration: Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn);
        }
        else{
          if(movieElement.sectionName!="Премьеры"){
          if(!loading){
              BlocProvider.of<HomeBloc>(context)..add(UpdateMovieEvent(movieElement.sectionName));
            loading=true;
          }
          }

        }
      },
      down: () {
        if (movieElement.sectionIndex == 0) {
          changeFocus(context, firstRowFocus[lastElement]);
          movieElement.lastElement = index;
          pageController.animateTo(500,
              duration: Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn);
        }
        else if (movieElement.sectionIndex == 1) {
          changeFocus(context,HomeClass.movieElements[2].categoryFocus);
          movieElement.lastElement = index;
          pageController.animateTo(850,
              duration: Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn);
        }else if(movieElement.sectionIndex==2){
          changeFocus(context, HomeClass.movieElements[3].categoryFocus);
          movieElement.lastElement = index;
          pageController.animateTo(1100,
              duration: Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn);
        }

      },
      left: () {
        if (movieElement.elementsFocus != null && index != 0) {
          _changeFocus(movieElement.elementsFocus![index - 1]);
          movieElement.scrollController.animateTo((index - 1) * 135,
              duration: Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn);
        }
      },
      child: Focus(
        focusNode: movieElement.elementsFocus?[index],
        child: Container(
          width: 135,
          child: Card(
            elevation: 5.0,
            clipBehavior: Clip.antiAlias,
            margin: (movieElement.elementsFocus != null && movieElement.elementsFocus![index].hasFocus)
                ? const EdgeInsets.symmetric(horizontal: 7, vertical: 3)
                : const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                  border: (movieElement.elementsFocus != null && movieElement.elementsFocus![index].hasFocus)
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



  changeFocus(BuildContext context, FocusNode node) {
    FocusScope.of(context).requestFocus(node);
    setState(() {});
  }
  void updateMovieCollection(dynamic newList,List<Film>  oldList,List<FocusNode> focusList,ScrollController scrollController){
    oldList.addAll(newList);
    int newElement=focusList.length;
    focusList.addAll(List.generate(
        newList.length, (index) => FocusNode()));
    FocusScope.of(context).requestFocus(focusList[newElement]);
    setState(() {
    });
    scrollController.animateTo((newElement ) * 135,
        duration: Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn);
  }
}
