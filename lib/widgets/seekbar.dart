import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:new_ucon/data/constants.dart';
import 'package:new_ucon/utils/actionHandler.dart';
import 'package:video_player/video_player.dart';

import '../blocs/movie/movie_bloc.dart';


class MySeekBar extends StatefulWidget {
  VideoPlayerController vlcPlayerController;
  Function upButtonIntent;
  Function rightButtonIntent;
  Function leftButtonIntent;
  Function downButtonIntent;
  Function enterButtonIntent;
  MySeekBar({Key? key,required this.vlcPlayerController,required this.upButtonIntent,required this.rightButtonIntent,required this.leftButtonIntent,required this.enterButtonIntent,required this.downButtonIntent}) : super(key: key);
  @override
  State<MySeekBar> createState() => _MySeekBarState();
}

class _MySeekBarState extends State<MySeekBar> {
  FocusNode focusNode=FocusNode();
  bool isFirst=true;
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    if(isFirst){
      FocusScope.of(context).requestFocus(focusNode);
      isFirst=false;
    }
    return  BlocBuilder<MovieBloc, MovieState>(
      buildWhen: (context,state){
        if(state is SeekBarUpdateState){
          return true;
        }else{
          return false;
        }
      },
  builder: (context, state) {
      if(state is SeekBarUpdateState){
        return Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(state.textCurrent,style:TextStyle(fontSize:16,color:Colors.white)),
            ),
            Expanded(
              child: ClickRemoteActionWidget(
                up:(){
                  widget.upButtonIntent();
    },
                down: (){
                  print("down");
                  widget.downButtonIntent();
                },
                enter: (){
                  print("enterPressed");
                  print(focusNode.hasFocus);
                  widget.enterButtonIntent();
                },
                right: (){
                  widget.rightButtonIntent();
                },
                left: (){
                  print("leftPressed");
                  widget.leftButtonIntent();
                },

                child: Focus(
                  focusNode: focusNode,
                  child: SliderTheme(
                    data: SliderThemeData(
                        thumbShape: RoundSliderThumbShape(enabledThumbRadius: focusNode.hasFocus?9:7)),
                    child: Slider
                      ( value: state.currentPosition.toDouble(),
                      min: 0,
                      max: state.length.toDouble(),
                     activeColor: focusNode.hasFocus?Colors.yellow:Colors.green,
                      inactiveColor: Colors.grey,
                      semanticFormatterCallback: (double newValue) {
                        return '${newValue.round()}';
                      }, onChanged: (double value) {  },
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(state.textLength,style:TextStyle(fontSize:16,color:Colors.white)),
            ),

          ],
        );
      }else{
       return  const SizedBox();
      }

  },
    );
  }
}
