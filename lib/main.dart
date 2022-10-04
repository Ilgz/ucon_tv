import 'package:flutter/material.dart';

import 'screens/reg_screen.dart';
import 'utils/actionHandler.dart';

void main() {
 runApp( MaterialApp(home:RegScreen()));
  //runApp( MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  IconData selectedIcon=Icons.one_k_outlined;
  late  FocusNode _icon1FocusNode;
  late FocusNode _icon2FocusNode;
  late  FocusNode _icon3FocusNode;
  late FocusNode _icon4FocusNode;
  @override
  void initState() {
    _icon1FocusNode=FocusNode();
    _icon2FocusNode=FocusNode();
    _icon3FocusNode=FocusNode();
    _icon4FocusNode=FocusNode();
    FocusScope.of(context).requestFocus(_icon1FocusNode);

    super.initState();
  }
  _changeFocus(BuildContext context,FocusNode node){
    FocusScope.of(context).requestFocus(node);
    setState((){});
  }
  @override
  void dispose() {
    _icon1FocusNode.dispose();
    _icon2FocusNode.dispose();
    _icon3FocusNode.dispose();
    _icon4FocusNode.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body:HandleRemoteActionsWidget(
          child: Column(
            mainAxisAlignment:MainAxisAlignment.center,children: [
          Container(
          padding: EdgeInsets.all(10),
          child: Icon(selectedIcon),
      ),
            Row(mainAxisAlignment:MainAxisAlignment.spaceEvenly,children: [
              Actions(
                actions: <Type,Action<Intent>>{
                  RightButtonIntent:CallbackAction<RightButtonIntent>(onInvoke:(intent)=> _changeFocus(context,_icon2FocusNode)),
                  LeftButtonIntent:CallbackAction<LeftButtonIntent>(onInvoke:(intent)=> _changeFocus(context,_icon4FocusNode)),
                  EnterButtonIntent:CallbackAction<EnterButtonIntent>(onInvoke:(intent)=>print("cho za huyna")),
                },
                child: Focus(
                  focusNode:_icon1FocusNode,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.one_k_outlined),
                    decoration: BoxDecoration(border:!_icon1FocusNode.hasFocus?null:Border.all(width: 5,color:Colors.black)),
                  ),
                ),
              ),
              Actions(
                actions: <Type,Action<Intent>>{
                  RightButtonIntent:CallbackAction<RightButtonIntent>(onInvoke:(intent)=> _changeFocus(context,_icon3FocusNode)),
                  LeftButtonIntent:CallbackAction<LeftButtonIntent>(onInvoke:(intent)=> _changeFocus(context,_icon1FocusNode)),
                },
                child: Focus(
                  focusNode: _icon2FocusNode,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.two_k_outlined),
                    decoration: BoxDecoration(border:!_icon2FocusNode.hasFocus?null:Border.all(width: 5,color:Colors.black)),
                  ),
                ),
              ),
              Actions(
                actions: <Type,Action<Intent>>{
                  RightButtonIntent:CallbackAction<RightButtonIntent>(onInvoke:(intent)=> _changeFocus(context,_icon4FocusNode)),
                  LeftButtonIntent:CallbackAction<LeftButtonIntent>(onInvoke:(intent)=> _changeFocus(context,_icon2FocusNode)),
                },
                child: Focus(
                  focusNode: _icon3FocusNode,
                  child: Container(

                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.three_k_outlined),
                    decoration: BoxDecoration(border:!_icon3FocusNode.hasFocus?null:Border.all(width: 5,color:Colors.black)),
                  ),
                ),
              ),
              Actions(
                actions: <Type,Action<Intent>>{
                  RightButtonIntent:CallbackAction<RightButtonIntent>(onInvoke:(intent)=> _changeFocus(context,_icon1FocusNode)),
                  LeftButtonIntent:CallbackAction<LeftButtonIntent>(onInvoke:(intent)=> _changeFocus(context,_icon3FocusNode)),
                },
                child: Focus(
                  focusNode: _icon4FocusNode,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.four_k_outlined),
                    decoration: BoxDecoration(border:!_icon4FocusNode.hasFocus?null:Border.all(width: 5,color:Colors.black)),
                  ),
                ),
              ),
            ],)
          ],),
        )
      ),
    );
  }
}
