import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/home/home_bloc.dart';
import '../views/profile_page.dart';
import '../utils/actionHandler.dart';

class ProfileIcon extends StatelessWidget {
  static final   FocusNode profileFocus = FocusNode();
  static bool willRequest=true;
  ProfileIcon({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ClickRemoteActionWidget(
      left: () {
        BlocProvider.of<HomeBloc>(context).add(ActionProfileSearchEvent());
      },
      enter: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const Profile()));
      },
      down: () {
        BlocProvider.of<HomeBloc>(context).add(ActionProfileSliderEvent());
      },
      child: BlocConsumer<HomeBloc, HomeState>(
        listener: (context,state){
          if(state is ActionProfileSliderState||state is ActionProfileSearchState){
            if(!willRequest){
              willRequest=true;
            }else{
              FocusScope.of(context).requestFocus(profileFocus);
              willRequest=false;

            }
          }
        },
        buildWhen: (context,state){
          if(state is ActionProfileSliderState||state is ActionProfileSearchState){

            return true;
          }else{
            return false;
          }
        },
        builder: (context, state) {
          return Focus(
            focusNode: profileFocus,
            child: Icon(
              Icons.person,
              color: profileFocus.hasFocus
                  ? Colors.orange
                  : Colors.white,
            ),
          );
        },
      ),
    );
  }
}

