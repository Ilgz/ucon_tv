import 'package:flutter/material.dart';

import '../../utils/actionHandler.dart';
class SeriesPopup extends StatefulWidget {
  final Function(List<int>) callback;
  final List<int> episodes;
  const SeriesPopup({super.key, required this.callback,required this.episodes});
  @override
  State<SeriesPopup> createState() => _SeriesPopupState();
}

class _SeriesPopupState extends State<SeriesPopup> {
  List<List<int>> episodeList=[];
 late  List<FocusNode> seasonsFocusNode ;
 late  List<FocusNode> episodesFocusNode ;
  bool isFirst=true;
  int? seasonIndex;
  ScrollController scrollController=ScrollController();
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    if(isFirst){
      for (var element in widget.episodes) {
        if(element==1) {
          episodeList.add([]);
        }
        episodeList.last.add(element);
        }
  seasonsFocusNode  = List.generate(episodeList.length, (index) => FocusNode());
      _changeFocus(seasonsFocusNode.first);
      isFirst=false;
    }
    return Dialog(
      backgroundColor: Colors.lightBlue.shade900,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0))),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: HandleRemoteActionsWidget(
          child: Container(
            width: 400,
            child: ListView.builder(controller:scrollController,shrinkWrap:true,itemCount:seasonIndex!=null?episodeList[seasonIndex!].length:episodeList.length,itemBuilder: (BuildContext context,int index){
    return ClickRemoteActionWidget(
      down: (){
        if(seasonIndex!=null){
              if(index!=(episodesFocusNode.length-1)){
                _changeFocus(episodesFocusNode[index+1]);
                scrollController.animateTo((index+1 ) * 60,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.fastOutSlowIn);
              }
        }else{
              if(index!=(seasonsFocusNode.length-1)){
                _changeFocus(seasonsFocusNode[index+1]);
                scrollController.animateTo((index+1 ) * 60,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.fastOutSlowIn);
              }

        }

      },up:(){
        if(seasonIndex!=null){
              if(index!=0){
                _changeFocus(episodesFocusNode[index-1]);
                scrollController.animateTo((index-1 ) * 60,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.fastOutSlowIn);
              }
        }else{
              if(index!=0){
                _changeFocus(seasonsFocusNode[index-1]);
                scrollController.animateTo((index-1 ) * 60,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.fastOutSlowIn);
              }
        }

    },
      enter: (){
        if(seasonIndex!=null){
              widget.callback([(seasonIndex!+1),episodeList[seasonIndex!][index]]);
              Navigator.pop(context);
        }
        else{
              seasonIndex=index;
              episodesFocusNode=List.generate(episodeList[seasonIndex!].length, (index) => FocusNode());
              _changeFocus(episodesFocusNode.first);
              setState(() {
              });
        }
      },
      child: Focus(
        focusNode: seasonIndex!=null?episodesFocusNode[index]:seasonsFocusNode[index],
        child:
        Container(
          decoration: BoxDecoration(border: Border(top: BorderSide())),
          child: ListTile(
              tileColor: (seasonIndex!=null?episodesFocusNode[index]:seasonsFocusNode[index]).hasFocus?Colors.white:Colors.lightBlue.shade900,
              leading: CircleAvatar(
                backgroundColor: Colors.transparent,
                    child: Text(
                      (index+1).toString(),
                        style: TextStyle(color: (seasonIndex!=null?episodesFocusNode[index]:seasonsFocusNode[index]).hasFocus?Colors.black:Colors.white),
                    ),
                  ),
       // leading:  Icon(Icons.play_arrow_outlined,color: (seasonIndex!=null?episodesFocusNode[index]:seasonsFocusNode[index]).hasFocus?Colors.yellow:Colors.black,),
              title: Text(seasonIndex!=null?"Серия":"Сезон",textAlign:TextAlign.start,style:TextStyle(color:(seasonIndex!=null?episodesFocusNode[index]:seasonsFocusNode[index]).hasFocus?Colors.black:Colors.white))),

        )
        ,
      ),
    );
              }),
          ),
          )
        ),
    );
  }
  _changeFocus(FocusNode focusNode){
    FocusScope.of(context).requestFocus(focusNode);
    setState(() {

    });
  }
}


