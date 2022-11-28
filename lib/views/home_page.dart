import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_ucon/blocs/home/home_bloc.dart';
import 'package:new_ucon/data/constants.dart';
import 'package:new_ucon/utils/actionHandler.dart';
import 'package:new_ucon/views/register_page.dart';
import 'package:new_ucon/widgets/listview_channel.dart';
import 'package:new_ucon/widgets/listview_movie.dart';
import 'package:new_ucon/widgets/profile_icon.dart';
import 'package:new_ucon/widgets/search_icon.dart';
import 'package:new_ucon/widgets/slider.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  late final  HomeBloc bloc;
  bool isFirst = true;

  @override
  Widget build(BuildContext context) {
    if (isFirst) {
      bloc = BlocProvider.of<HomeBloc>(context);
      bloc.add(CheckRegistrationEvent());
      isFirst = false;
    }
    return WillPopScope(
      onWillPop: () async {
        bloc.add(HomeBackButtonEvent());
        return false;
      },
      child: HandleRemoteActionsWidget(
        child: BlocConsumer<HomeBloc, HomeState>(
          buildWhen: (context, state) {
            if (state is CheckRegistrationState) {
              return true;
            } else {
              return false;
            }
          },
          listener: (context, state) {
            if(state is HomeBackButtonSuccessState){
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            }else if(state is HomeBackButtonWarningState){
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content:
                      Text("Нажмите кнопку \"Назад\" еще раз,чтобы выйти из приложения.")));
            }
            else if (state is CheckRegistrationState) {
              if (state.server == null) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegScreen(),
                  ),
                  (route) =>
                      false, //if you want to disable back feature set to false
                );
              } else {
                bloc.add(LoadHomeDataEvent());
                FocusScope.of(context).requestFocus(HomeClass.sliderFocus);
              }
            }
          },
          builder: (context, state) {
            if (state is CheckRegistrationState) {
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image:
                          Image.asset('assets/images/background_home.jpg').image,
                      fit: BoxFit.cover),
                ),
                child: Scaffold(
                  appBar: AppBar(
                      backgroundColor: const Color(0xff00001c),
                      title: const Text("UconTV"),
                      actions: [
                        SearchIcon(),
                        const SizedBox(
                          width: 20,
                        ),
                        ProfileIcon()
                      ]),
                  backgroundColor: Colors.transparent,
                  body: buildPage(),
                ),
              );
            } else {
              return Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: Image.asset('assets/images/background_home.jpg')
                            .image,
                        fit: BoxFit.cover),
                  ),
                  child: const Scaffold(
                      backgroundColor: Colors.transparent,
                      body: Center(
                        child: CircularProgressIndicator(
                          color: Colors.red,
                        ),
                      )));
            }
          },
        ),
      ),
    );
  }

  Widget buildPage() {
    return SingleChildScrollView(
      controller: HomeClass.pageController,
      child: BlocConsumer<HomeBloc, HomeState>(
        buildWhen: (context, state) {
          if (state is LoadHomeDataSuccessState) {
            return true;
          } else {
            return false;
          }
        },
        listener: (context, state) {
          if (state is LoadHomeDataSuccessState) {
            for (var element in HomeClass.movieElements) {
              if (element.sectionName == "Фильмы") {
                element.elements = state.filmList;
                element.elementsFocus ??= List.generate(
                    state.filmList.length, (index) => FocusNode());
              } else if (element.sectionName == "Сериалы") {
                element.elements = state.serialList;
                element.elementsFocus ??= List.generate(
                    state.serialList.length, (index) => FocusNode());
              } else if (element.sectionName == "Премьеры") {
                element.elements = state.premierList;
                element.elementsFocus ??= List.generate(
                    state.premierList.length, (index) => FocusNode());
              } else if (element.sectionName == "Мультфильмы") {
                element.elements = state.cartoonList;
                element.elementsFocus ??= List.generate(
                    state.cartoonList.length, (index) => FocusNode());
              }
            }
          }
        },
        builder: (context, state) {
          if (state is LoadHomeDataSuccessState) {
            return Column(children: [
              MySlider(),
              ListViewMovie(movieElement: HomeClass.movieElements[0]),
              ListViewChannel(),
              ListViewMovie(movieElement: HomeClass.movieElements[1]),
              ListViewMovie(movieElement: HomeClass.movieElements[2]),
            ]);
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
