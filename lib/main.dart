import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_ucon/home/home_bloc.dart';
import 'package:new_ucon/movie/movie_bloc.dart';
import 'package:new_ucon/screens/home.dart';

void main() {
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<MovieBloc>(
        create: (context) => MovieBloc(),
      ),
      BlocProvider<HomeBloc>(
        create: (context) => HomeBloc(),
      ),

    ],
    child: MaterialApp(debugShowCheckedModeBanner: false, home: HomePage()),
  ));
  //runApp( MyApp());
}

