import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:new_ucon/movie/movie_bloc.dart';

class MyVideoPlayer extends StatefulWidget {
  VlcPlayerController vlcPlayerController;
  MyVideoPlayer({Key? key,required this.vlcPlayerController }) : super(key: key);
  @override
  State<MyVideoPlayer> createState() => _MyVideoPlayerState();
}

class _MyVideoPlayerState extends State<MyVideoPlayer> {
  @override
  Widget build(BuildContext context) {
    return  BlocBuilder<MovieBloc, MovieState>(
  builder: (context, state) {
    if(state is SeekBarUpdateState){
      print(state.textCurrent);
      return Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(state.textCurrent,style:TextStyle(fontSize:16,color:Colors.white)),
          ),
          Expanded(
            child: SliderTheme(
              data: SliderThemeData(
                  thumbColor: Colors.green,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 7)),
              child: Slider
                ( value: state.currentPosition.toDouble(),
                min: 0,
                max: state.length.toDouble(),
                //thumbColor: Colors.blue,
               activeColor: Colors.green,
                inactiveColor: Colors.grey,
                semanticFormatterCallback: (double newValue) {
                  return '${newValue.round()}';
                }, onChanged: (double value) {  },
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
     return  Container();
    }

  },
);
  }
}
