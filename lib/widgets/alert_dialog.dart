import 'package:flutter/material.dart';

import '../utils/actionHandler.dart';
class QuitPopup extends StatefulWidget {
  final String warningText;
  final Function func;

  const QuitPopup({super.key, required this.warningText, required this.func});

  @override
  State<QuitPopup> createState() => _QuitPopupState();
}

class _QuitPopupState extends State<QuitPopup> {
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 15),
              Text(
                'Выход',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 15),
              Text(
                widget.warningText,
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
                            color: Colors.white,
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
                                              color: cancelButtonFocus!.hasFocus
                                                  ? Colors.orange
                                                  : Colors.black87,
                                              fontWeight: FontWeight.w600)),
                                    )))),
                      ),
                    ),
                    //   Expanded(flex: 1, child: SizedBox()),
                    Expanded(
                        flex: 2,
                        child: ClickRemoteActionWidget(
                          left: (){
                            FocusScope.of(context).requestFocus(cancelButtonFocus);
                            setState(() {

                            });
                          },
                          child: Card(
                            color: Colors.black87,
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
                                      child: Text("Выйти",
                                          style: TextStyle(
                                              color: continueButtonFocus!.hasFocus
                                                  ? Colors.orange
                                                  : Colors.white,
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
    );
  }
}


