import 'package:flutter/material.dart';

import '../model/serial.dart';
import '../utils/actionHandler.dart';
class SeriesPopup extends StatefulWidget {
  final Function(int) callback;
  final List<PlaylistElement> playList;
  const SeriesPopup({super.key, required this.callback,required this.playList});
  @override
  State<SeriesPopup> createState() => _SeriesPopupState();
}

class _SeriesPopupState extends State<SeriesPopup> {

 late  List<FocusNode> seriesFocusNode ;
  bool isFirst=true;

  @override
  Widget build(BuildContext context) {
    if(isFirst){
  seriesFocusNode  = List.generate(widget.playList.length, (index) => FocusNode());
      _changeFocus(seriesFocusNode.last);
      isFirst=false;
    }
    return Dialog(
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0))),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: HandleRemoteActionsWidget(
          child: ListView.builder(shrinkWrap:true,itemCount:widget.playList.length,itemBuilder: (BuildContext context,int index){
    return ClickRemoteActionWidget(
      down: (){
        if(index!=(seriesFocusNode.length-1)){
          _changeFocus(seriesFocusNode[index+1]);
        }
      },up:(){
      if(index!=0){
        _changeFocus(seriesFocusNode[index-1]);
      }
    },
      enter: (){
        widget.callback(index);
        Navigator.pop(context);
      },
      child: Focus(
        focusNode: seriesFocusNode[index],
        child: ListTile(
          tileColor: index==3?Colors.yellow:Colors.black,
        leading:  Icon(Icons.play_arrow_outlined,color: seriesFocusNode[index].hasFocus?Colors.yellow:Colors.black,),

        title: Text("${index+1} Серия",style:TextStyle(color: Colors.white))),
      ),
    );
          })
        ),
      ),
    );
  }
  _changeFocus(FocusNode focusNode){
    FocusScope.of(context).requestFocus(focusNode);
    setState(() {

    });
  }
}


