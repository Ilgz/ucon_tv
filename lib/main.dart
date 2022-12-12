import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_ucon/blocs/category/category_bloc.dart';
import 'package:new_ucon/blocs/channel/channel_bloc.dart';
import 'package:new_ucon/blocs/register/register_bloc.dart';
import 'package:new_ucon/views/channel_play_page.dart';
import 'package:new_ucon/views/home_page.dart';
import 'package:new_ucon/views/register_page.dart';
import 'blocs/home/home_bloc.dart';
import 'blocs/movie/movie_bloc.dart';
class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
void main() {
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<MovieBloc>(
        create: (context) => MovieBloc(),
      ),
      BlocProvider<HomeBloc>(
        create: (context) => HomeBloc(),
      ),
      BlocProvider<CategoryBloc>(
        create: (context) => CategoryBloc(),
      ),
      BlocProvider<RegisterBloc>(
        create: (context) => RegisterBloc(),
      ),
      BlocProvider<ChannelBloc>(
        create: (context) => ChannelBloc(),
      ),

    ],
    child: MaterialApp(debugShowCheckedModeBanner: false, home:  HomePage()),
  ));
  HttpOverrides.global = MyHttpOverrides();
}

