import 'package:flutter/material.dart';
import 'package:new_ucon/data/producers.dart';

import '../../models/producer_model.dart';
import '../../utils/actionHandler.dart';
class CategoryDialog extends StatefulWidget {
  final Function(Producer) callback;
  String sectionName;
   CategoryDialog({super.key,required this.sectionName,required this.callback});
  @override
  State<CategoryDialog> createState() => _CategoryDialogState();
}

class _CategoryDialogState extends State<CategoryDialog> {
  bool isFirst=true;
  ScrollController scrollController=ScrollController();
  late ProducerClass producerClass=ProducerClass(widget.sectionName);
  late List<Producer> producerList=producerClass.categories();
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
              width: 500,
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
                    widget.callback(producerList[index]);
                    Navigator.pop(context);
                      _changeFocus(producerFocusList.first);

                  },
                  child: Focus(
                    focusNode: producerFocusList[index],
                    child:
                    Container(
                      decoration: BoxDecoration(border: Border(top: BorderSide())),
                      child: ListTile(
                          visualDensity: VisualDensity(vertical: -4),
                          tileColor: producerFocusList[index].hasFocus?Colors.white:Colors.lightBlue.shade900,
                          leading: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: Text(
                              (index+1).toString(),
                              style: TextStyle(color:producerFocusList[index].hasFocus?Colors.black:Colors.white),
                            ),
                          ),
                          // leading:  Icon(Icons.play_arrow_outlined,color: (seasonIndex!=null?episodesFocusNode[index]:seasonsFocusNode[index]).hasFocus?Colors.yellow:Colors.black,),
                          title: Text(producerList[index].name,textAlign:TextAlign.start,style:TextStyle(color:producerFocusList[index].hasFocus?Colors.black:Colors.white))),
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


