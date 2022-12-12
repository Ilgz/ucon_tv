import 'package:flutter/material.dart';
import 'package:new_ucon/data/channels.dart';
import 'package:new_ucon/models/channel_model.dart';
import '../../utils/actionHandler.dart';
class ChannelCategoryDialog extends StatefulWidget {
  final Function(List<Channel>) callback;
  ChannelCategoryDialog({super.key,required this.callback});
  @override
  State<ChannelCategoryDialog> createState() => _ChannelCategoryDialogState();
}

class _ChannelCategoryDialogState extends State<ChannelCategoryDialog> {
  bool isFirst=true;
  ScrollController scrollController=ScrollController();
  late List<String> producerList=["Все","Фильмы/Сериалы","Новостные","Спортивные","Музыкальные","Детские","Международные"];
  late List<FocusNode> producerFocusList=List.generate(producerList.length, (index) => FocusNode());
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    if(isFirst){
      _changeFocus(producerFocusList.first);
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
              child: ListView.builder(controller:scrollController,shrinkWrap:true,itemCount:producerList.length,itemBuilder: (BuildContext context,int index){
                return ClickRemoteActionWidget(
                  down: (){
                    if(index!=(producerFocusList.length-1)){
                      _changeFocus(producerFocusList[index+1]);
                      scrollController.animateTo((index+1 ) * 60,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.fastOutSlowIn);
                    }


                  },up:(){
                  if(index!=0){
                    _changeFocus(producerFocusList[index-1]);
                    scrollController.animateTo((index-1 ) * 60,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.fastOutSlowIn);
                  }


                },
                  enter: (){
                    if(index==0){
                      widget.callback(Channels.all);
                    }else if(index==1){
                      widget.callback(Channels.film);
                    }else if(index==2){
                      widget.callback(Channels.news);
                    }else if(index==3){
                      widget.callback(Channels.sport);
                    }else if(index==4){
                      widget.callback(Channels.music);
                    }else if(index==5){
                      widget.callback(Channels.child);
                    }else{
                      widget.callback(Channels.inter);
                    }
                    print(index);
                    Navigator.pop(context);

                  },
                  child: Focus(
                    focusNode: producerFocusList[index],
                    child:
                    Container(
                      decoration: BoxDecoration(border: Border(top: BorderSide())),
                      child:  ListTile(
                          visualDensity: VisualDensity(vertical: -4),
                          tileColor: producerFocusList[index].hasFocus?Colors.white:Colors.lightBlue.shade900,
                          leading: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: Text(
                              (index+1).toString(),
                              style: TextStyle(color:producerFocusList[index].hasFocus?Colors.black:Colors.white,fontWeight: FontWeight.bold),
                            ),
                          ),
                          // leading:  Icon(Icons.play_arrow_outlined,color: (seasonIndex!=null?episodesFocusNode[index]:seasonsFocusNode[index]).hasFocus?Colors.yellow:Colors.black,),
                          title: Text(producerList[index],textAlign:TextAlign.start,style:TextStyle(color:producerFocusList[index].hasFocus?Colors.black:Colors.white))),
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


