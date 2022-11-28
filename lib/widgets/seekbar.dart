import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:new_ucon/data/constants.dart';
import 'package:new_ucon/utils/actionHandler.dart';

import '../blocs/movie/movie_bloc.dart';


class MySeekBar extends StatefulWidget {
  VlcPlayerController vlcPlayerController;
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
  @override
  Widget build(BuildContext context) {
    return  BlocBuilder<MovieBloc, MovieState>(
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
                  widget.downButtonIntent();
                },
                enter: (){
widget.enterButtonIntent();
                },
                right: (){
                  widget.rightButtonIntent();
                },
                left: (){
                  widget.leftButtonIntent();
                },

                child: Focus(
                  focusNode: MoviePlayClass.seekBarFocus,
                  child: SliderTheme(
                    data: SliderThemeData(
                        thumbShape: RoundSliderThumbShape(enabledThumbRadius: MoviePlayClass.seekBarFocus.hasFocus?9:7)),
                    child: Slider
                      ( value: state.currentPosition.toDouble(),
                      min: 0,
                      max: state.length.toDouble(),
                     activeColor: MoviePlayClass.seekBarFocus.hasFocus?Colors.yellow:Colors.green,
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
