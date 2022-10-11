import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_ucon/home/home_bloc.dart';
import 'package:new_ucon/screens/home.dart';
void main() {
 runApp( MaterialApp(debugShowCheckedModeBanner:false,home:BlocProvider(
  create: (context) => HomeBloc(),
  child: HomePage(),
)));
  //runApp( MyApp());
}

