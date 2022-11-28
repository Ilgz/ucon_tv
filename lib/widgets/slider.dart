import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_ucon/data/constants.dart';

import '../blocs/home/home_bloc.dart';
import '../models/film_model.dart';
import '../views/movie_play_page.dart';
import '../utils/actionHandler.dart';

class MySlider extends StatelessWidget {
  static CarouselController carouselController=CarouselController();
  static bool willRequest=false;
  MySlider({Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context,state){

        if(state is LoadHomeDataSuccessState){
          HomeClass.sliderList.addAll(state.sliderList);
        }
        if(state is ActionProfileSliderState||state is ActionSliderSearchState||state is ActionSliderCategoryOneState){
          if(!willRequest){
            willRequest=true;
          }else{
            FocusScope.of(context).requestFocus(HomeClass.sliderFocus);willRequest=false;
          }
        }
      },
      buildWhen: (context,state){
        if(state is LoadHomeDataSuccessState||state is ActionProfileSliderState||state is ActionSliderRebuildState||state is ActionSliderSearchState||state is ActionSliderCategoryOneState){
          return true;
        }else{
          return false;
        }
      },
      builder: (context, state) {
        if(state is LoadHomeDataSuccessState) {
          HomeClass.sliderList.addAll(state.sliderList);
          return _buildSlider(context);
        }else if(state is ActionProfileSliderState||state is ActionSliderSearchState||state is ActionSliderRebuildState||state is ActionSliderCategoryOneState){
          return _buildSlider(context);
        }
        return const SizedBox();
      },
    );
  }

  ClickRemoteActionWidget _buildSlider(BuildContext context) {
    return ClickRemoteActionWidget(
          enter: () {
            if ((HomeClass.sliderFocus.hasFocus)) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          MoviePlay(
                              film: Film(
                                  name: HomeClass.sliderList[HomeClass
                                      .activeIndex]
                                      .name,
                                  imageLink: HomeClass.sliderList[HomeClass.activeIndex]
                                      .image,
                                  siteLink: HomeClass.sliderList[HomeClass
                                      .activeIndex]
                                      .site,details: ""))));
            }
          },
          up: () {
            BlocProvider.of<HomeBloc>(context).add(ActionProfileSliderEvent());
          },
          right: () {
            carouselController.nextPage(
                duration: const Duration(milliseconds: 500));

          },
          left: () {
            carouselController.previousPage(
                duration: const Duration(milliseconds: 500));

          },
          down: () {
            BlocProvider.of<HomeBloc>(context).add(ActionSliderCategoryOneEvent());
            HomeClass.pageController.animateTo(270,
                duration: const Duration(milliseconds: 500),
                curve: Curves.fastOutSlowIn);
          },
          child: Focus(
            focusNode: HomeClass.sliderFocus,
            child: Container(
              child: CarouselSlider.builder(
                carouselController: carouselController,
                options: CarouselOptions(
                  height: 250,
                  viewportFraction: 0.4,
                  enableInfiniteScroll: true,
                  onPageChanged: (index, reason) {
                    HomeClass.activeIndex = index;
                    BlocProvider.of<HomeBloc>(context).add(ActionSliderRebuildEvent());
                  },
                ),
                itemCount: HomeClass.sliderList.length,
                itemBuilder: (context, index, realIndex) {
                  final urlImage = HomeClass.sliderList[index].sliderImage;
                  return Container(
                    decoration: BoxDecoration(
                        border: (index == HomeClass.activeIndex &&
                            HomeClass.sliderFocus.hasFocus)
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
                                      HomeClass.sliderList[index].name,
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white.withOpacity(1)),
                                    ))))
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
  }


}


