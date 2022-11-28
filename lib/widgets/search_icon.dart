import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/home/home_bloc.dart';
import '../views/search_page.dart';
import '../utils/actionHandler.dart';

class SearchIcon extends StatelessWidget {
  static final FocusNode searchFocus = FocusNode();
  static bool willRequest = true;

  SearchIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClickRemoteActionWidget(
        right: () {
          BlocProvider.of<HomeBloc>(context).add(ActionProfileSearchEvent());
        },
        enter: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const SearchHome()));
        },
        down: () {
          BlocProvider.of<HomeBloc>(context).add(ActionSliderSearchEvent());
        },
        child: BlocConsumer<HomeBloc, HomeState>(
          listener: (context,state){
            if(state is ActionProfileSearchState||state is ActionSliderSearchState){
              if(!willRequest){
                willRequest=true;
              }else{
                FocusScope.of(context).requestFocus(searchFocus);
                willRequest=false;

              }
            }
          },
          buildWhen: (context,state){
            if(state is ActionProfileSearchState||state is ActionSliderSearchState){
              return true;
            }else{
              return false;
            }
          },
          builder: (context, state) {
            return Focus(
              focusNode: searchFocus,
              child: Icon(
                Icons.search,
                color: searchFocus.hasFocus
                    ? Colors.orange
                    : Colors.white,
              ),
            );
          },
        ));
  }
}

