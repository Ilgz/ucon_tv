import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:new_ucon/constants.dart';

import '../home/home_bloc.dart';
import '../model/film.dart';
import '../screens/movie_play.dart';
import '../utils/actionHandler.dart';
class MySlider extends StatefulWidget {
  final LoadHomeDataSuccessState state;
  final ScrollController pageController;
  final Function setStateFunction;
  final BuildContext mainContext;
  const MySlider({Key? key,required this.state,required this.pageController,required this.setStateFunction,required this.mainContext}) : super(key: key);

  @override
  State<MySlider> createState() => _MySliderState();
}

class _MySliderState extends State<MySlider> {
  @override
  Widget build(BuildContext context) {
    print("slideBuild");
    return ClickRemoteActionWidget(
      enter: () {
        if ((HomeClass.sliderFocusNode.hasFocus)) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MoviePlay(
                      film: Film(
                          name: widget.state.sliderList[HomeClass.activeIndex].name,
                          imageLink: widget.state
                              .sliderList[HomeClass.activeIndex].intentImgUrl,
                          siteLink: widget.state.sliderList[HomeClass.activeIndex]
                              .intentSiteLink))));
        }
      },
      up: () {
        FocusScope.of(widget.mainContext).requestFocus(HomeClass.profileFocus);
        widget.setStateFunction();
      },
      right: () {
        HomeClass.carouselController.nextPage(
              duration: const Duration(milliseconds: 500));

      },
      left: () {
          HomeClass.carouselController.previousPage(
              duration: const Duration(milliseconds: 500));
        },
      down: () {
        if (HomeClass.movieElements[0].elementsFocus != null) {
          widget.pageController.animateTo(270,
              duration: const Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn);
           FocusScope.of(widget.mainContext).requestFocus(HomeClass.movieElements[0].categoryFocus);
           widget.setStateFunction();

        }
      },
      child: Focus(
        focusNode: HomeClass.sliderFocusNode,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: CarouselSlider.builder(
            carouselController: HomeClass.carouselController,
            options: CarouselOptions(
              height: 250,
              viewportFraction: 0.6,
              enableInfiniteScroll: true,
              onPageChanged: (index, reason) {
                HomeClass.activeIndex = index;
                setState(() {

                });
              },
            ),
            itemCount: widget.state.sliderList.length,
            itemBuilder: (context, index, realIndex) {
              final urlImage = widget.state.sliderList[index].link;
              return buildImage(
                  urlImage,
                  index,
                  widget.state.sliderList[index].name,
                  widget.state.sliderList[index].intentImgUrl,
                  widget.state.sliderList[index].intentSiteLink);
            },
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
      ) {
    return  Container(
        decoration: BoxDecoration(
            border: (index == HomeClass.activeIndex && HomeClass.sliderFocusNode!.hasFocus)
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
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black,
                          ],
                        )),
                    child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          name,
                          style: TextStyle(
                              fontSize: 18, color: Colors.white.withOpacity(1)),
                        ))))
          ],
        ),
      );
  }
}


