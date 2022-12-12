import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_ucon/utils/actionHandler.dart';
import 'package:new_ucon/views/category_page.dart';
import 'package:new_ucon/widgets/channel_item.dart';
import 'package:new_ucon/widgets/dialogs/access_server_dialog.dart';

import '../blocs/home/home_bloc.dart';
import '../data/channels.dart';
import '../data/constants.dart';
class ListViewChannel extends StatelessWidget {
  ListViewChannel({Key? key}) : super(key: key);
  static List<FocusNode> firstRowFocus=List.generate(getDoubleChannels()[0].length, (index) => FocusNode());
  static List<FocusNode> secondRowFocus=List.generate(getDoubleChannels()[1].length, (index) => FocusNode());
  static FocusNode recoFocus=FocusNode();
 static  ScrollController channelScrollController = ScrollController();
 static bool firstWillRequest = true;
 static bool secondWillRequest = true;
 static bool recoWillRequest=true;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
         const SizedBox(height: 20),
        Row(
          children: [
            ClickRemoteActionWidget(
              up: (){
                BlocProvider.of<HomeBloc>(context).add(ActionMovieOneRecommendationsEvent());
                HomeClass.pageController.animateTo(270,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.fastOutSlowIn);
              },
              down: (){
                BlocProvider.of<HomeBloc>(context).add(ActionCategoryTwoRecommendationsEvent());
                HomeClass.pageController.animateTo(610,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.fastOutSlowIn);
              },
              right: (){
                BlocProvider.of<HomeBloc>(context).add(ActionRowOneRecommendationsEvent());
              },
              enter: (){
                if(UserAccount.server==1){
                  showDialog(context: context, builder: (context)=>AccessServer());
                }else{
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>CategoryPage(sectionName: 'reco')));
                }
              },

              child: Focus(
                focusNode: recoFocus,
                child: BlocConsumer<HomeBloc, HomeState>(
  listener: (context, state) {
    if(state is ActionMovieOneRecommendationsState||state is ActionRowOneRecommendationsState||state is ActionRowTwoRecommendationsState||state is ActionRowTwoRecommendationsState||state is ActionCategoryTwoRecommendationsState){
        if (!recoWillRequest) {
          recoWillRequest = true;
        } else {
          FocusScope.of(context).requestFocus(
                  recoFocus);
          recoWillRequest = false;
        }
    }
  },
                  buildWhen: (context,state){
                     if(state is ActionMovieOneRecommendationsState||state is ActionRowOneRecommendationsState||state is ActionRowTwoRecommendationsState||state is ActionRowTwoRecommendationsState||state is ActionCategoryTwoRecommendationsState){
                       return true;
                     }
                     return false;
                  },
  builder: (context, state) {
    return Container( decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
        border:recoFocus.hasFocus?Border.all(color: Colors.yellow, width: 5):null,
                ),child: ClipRRect(borderRadius:BorderRadius.circular(4),child: Image.asset("assets/images/hd_films.jpg",height: 190,width: 140,fit: BoxFit.cover,isAntiAlias: true,)));
  },
),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      controller: channelScrollController,
                      shrinkWrap: true,
                      primary: false,
                      scrollDirection: Axis.horizontal,
                      itemCount: getDoubleChannels()[0].length,
                      itemBuilder: (context, index) {
                        return BlocConsumer<HomeBloc, HomeState>(
  listener: (context, state) {
    if(state is ActionMovieOneRowOneState||state is ActionRowOneRowTwoState||state is ActionRowOneRecommendationsState){
      if(index==HomeClass.channelIndex){
                  if (!firstWillRequest) {
                    firstWillRequest = true;
                  } else {
                    FocusScope.of(context).requestFocus(
                        firstRowFocus[index]);
                    firstWillRequest = false;
                  }
      }
    } else if (state is ActionRowOneRightState) {
      if(index==state.index){
                  FocusScope.of(context).requestFocus(
                      firstRowFocus[index+1]);
                  channelScrollController.animateTo((index + 1) * 160,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.fastOutSlowIn);
      }
    }
    else if (state is ActionRowOneLeftState) {
      if(index==state.index){
                  FocusScope.of(context).requestFocus(
                      firstRowFocus[index-1]);
                  channelScrollController.animateTo((index - 1) * 160,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.fastOutSlowIn);
      }
    }
  },
                          buildWhen: (context,state){
    if(state is ActionMovieOneRowOneState||state is ActionRowOneRowTwoState||state is ActionRowOneRecommendationsState) {
      return true;
    } else  if(state is ActionRowOneRightState){
      if(index==state.index){
                  return true;
      }else if(index==(state.index+1)){
                  return true;
      }else{
                  return false;
      }
    }
    else  if(state is ActionRowOneLeftState){
      if(index==state.index){
                  return true;
      }else if(index==(state.index-1)){
                  return true;
      }else{
                  return false;
      }
    }
    else{
      return false;
    }
    },
  builder: (context, state) {
    return ChannelItem(channel:getDoubleChannels()[0][index],index:index,
                            focusNode:firstRowFocus[index], row:0,focusList: firstRowFocus);
  },
);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      controller: channelScrollController,
                      shrinkWrap: true,
                      primary: false,
                      scrollDirection: Axis.horizontal,
                      itemCount: getDoubleChannels()[1].length,
                      itemBuilder: (context, index) {
                        return BlocConsumer<HomeBloc, HomeState>(
                          listener: (context, state) {
                            if(state is ActionRowOneRowTwoState||state is ActionRowTwoCategoryTwoState||state is ActionRowTwoRecommendationsState){
                              if(index==HomeClass.channelIndex){
                                if (!secondWillRequest) {
                                  secondWillRequest = true;
                                } else {
                                  FocusScope.of(context).requestFocus(
                                      secondRowFocus[index]);
                                  secondWillRequest = false;
                                }
                              }
                            }
                            else if (state is ActionRowTwoRightState) {
                              if(index==state.index){
                                FocusScope.of(context).requestFocus(
                                    secondRowFocus[index+1]);
                                channelScrollController.animateTo((index + 1) * 160,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.fastOutSlowIn);
                              }
                            }
                            else if (state is ActionRowTwoLeftState) {
                              if(index==state.index){
                                FocusScope.of(context).requestFocus(
                                    secondRowFocus[index-1]);
                                channelScrollController.animateTo((index - 1) * 160,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.fastOutSlowIn);
                              }
                            }
                          },
                          buildWhen: (context,state){
                            if(state is ActionRowOneRowTwoState||state is ActionRowTwoCategoryTwoState||state is ActionRowTwoRecommendationsState) {
                              return true;
                            }
                            else  if(state is ActionRowTwoRightState){
                              if(index==state.index){
                                return true;
                              }else if(index==(state.index+1)){
                                return true;
                              }else{
                                return false;
                              }
                            }
                            else  if(state is ActionRowTwoLeftState){
                              if(index==state.index){
                                return true;
                              }else if(index==(state.index-1)){
                                return true;
                              }else{
                                return false;
                              }
                            }else{
                              return false;
                            }
                          },
                          builder: (context, state) {
                            return ChannelItem(channel:getDoubleChannels()[1][index],index:index,
                                focusNode:secondRowFocus[index], row:1,focusList: secondRowFocus);
                          },
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),

      ],
    );
  }
}
