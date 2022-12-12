import 'package:flutter/material.dart';
import 'package:new_ucon/data/constants.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/actionHandler.dart';
class ChangePlayerPopup extends StatefulWidget {

  const ChangePlayerPopup({super.key});

  @override
  State<ChangePlayerPopup> createState() => _ChangePlayerPopupState();
}

class _ChangePlayerPopupState extends State<ChangePlayerPopup> {
  FocusNode? cancelButtonFocus;

  FocusNode continueButtonFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    if (cancelButtonFocus == null) {
      cancelButtonFocus = FocusNode();
      FocusScope.of(context).requestFocus(cancelButtonFocus);
    }
    return Dialog(
      backgroundColor: Colors.grey[200],
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0))),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: HandleRemoteActionsWidget(
          child: SizedBox(
            width: 500,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 15),
                Text(
                  'Плеер',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  "Вы действительно хотите сменить ваш плеер?",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Divider(
                  height: 1,
                ),
                Container(
                  color: Colors.transparent,
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        flex: 2,
                        child: ClickRemoteActionWidget(
                          enter: () {
                            Navigator.of(context).pop();
                          },
                          right: () {
                            FocusScope.of(context)
                                .requestFocus(continueButtonFocus);
                            setState(() {});
                          },
                          child: Card(
                              color: cancelButtonFocus!.hasFocus
                                  ? Colors.orange
                                  : Colors.black87,
                              elevation: 3,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: Container(
                                  height: 50,
                                  child: Center(
                                      child: Focus(
                                        focusNode: cancelButtonFocus!,
                                        child: Text("Отмена",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600)),
                                      )))),
                        ),
                      ),
                      //   Expanded(flex: 1, child: SizedBox()),
                      Expanded(
                          flex: 2,
                          child: ClickRemoteActionWidget(
                            enter: ()async{
                              final prefs = await SharedPreferences.getInstance();
                              if(UserAccount.isVlc){
                                await prefs.setBool("isVlc", false);
                              }else{
                                await prefs.setBool("isVlc", true);
                              }
                              Restart.restartApp();

                            },
                            left: (){
                              FocusScope.of(context).requestFocus(cancelButtonFocus);
                              setState(() {

                              });
                            },
                            child: Card(
                              color: continueButtonFocus!.hasFocus
                                  ? Colors.orange
                                  : Colors.black87,
                              elevation: 3,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: Container(
                                  height: 50,
                                  child: Center(
                                      child: Focus(
                                        focusNode: continueButtonFocus,
                                        child: Text("Сменить",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600)),
                                      ))),
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


