import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:new_ucon/views/home_page.dart';
import 'package:new_ucon/widgets/dialogs/change_player_dialog.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/constants.dart';
import '../utils/actionHandler.dart';
import '../widgets/dialogs/alert_dialog.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  FocusNode? backButtonFocus;
  FocusNode exitButtonFocus = FocusNode();
  FocusNode changeVPSButtonFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    if (backButtonFocus == null) {
      backButtonFocus = FocusNode();
      FocusScope.of(context).requestFocus(backButtonFocus);
    }
    return HandleRemoteActionsWidget(
        child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: Image.asset('assets/images/background_home.jpg').image,
                  fit: BoxFit.cover),
            ),
            child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClickRemoteActionWidget(
                                enter: () {
                                  Navigator.pop(context);
                                },
                                down: () {
                                  _changeFocus(exitButtonFocus);
                                },
                                child:  Focus(
                                    focusNode: backButtonFocus,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child:CircleAvatar(
                                        radius: 20,
                                        backgroundColor:
                                        backButtonFocus!.hasFocus?Colors.orange.withOpacity(1):Colors.black.withOpacity(1),
                                        child: Icon(Icons.arrow_back,
                                            color: backButtonFocus!.hasFocus
                                                ? Colors.black
                                                : Colors.white),

                                      ),
                                    ))),
                            const SizedBox(
                              height: 10,
                            ),
                            Expanded(
                                child: Container(
                              decoration: BoxDecoration(
                                  color: const Color(0xff23395d).withOpacity(0.7),
                                  borderRadius:
                                      const BorderRadius.all(Radius.circular(20))),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                      margin: const EdgeInsets.all(8),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: const Color(0xff171719)
                                              .withOpacity(0.9),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      width: double.infinity,
                                      child: Text(UserAccount.phoneNumber.replaceAll("996", "0"),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Color(0xffd8d8d8),
                                              fontSize: 22))),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Container(
                                              margin: const EdgeInsets.all(4),
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                  color: const Color(0xff171719)
                                                      .withOpacity(0.9),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              width: double.infinity,
                                              child:  Text(
                                                "Ваш баланс ${UserAccount.balance} сом",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Color(0xffd8d8d8),
                                                    fontSize: 16),
                                              ))),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                          child: ClickRemoteActionWidget(
                                              enter: () {
                                                showDialog(
                                                    barrierDismissible: false,
                                                    context: context,
                                                    builder: (BuildContext context) => QuitPopup(
                                                        warningText: "Вы действительно хотите выйти из текущей учетной записи?",
                                                        func: () async {
                                                          final prefs =await  SharedPreferences.getInstance();
                                                          await prefs.remove("server");
                                                          await prefs.remove("phoneNumber");
                                                          Restart.restartApp();
                                                        }));
                                              },
                                              up: () {
                                                _changeFocus(backButtonFocus!);
                                              },
                                              down: () {
                                                _changeFocus(
                                                    changeVPSButtonFocus);
                                              },
                                              child: Focus(
                                                  focusNode: exitButtonFocus,
                                                  child: Container(
                                                      margin: const EdgeInsets.all(4),
                                                      padding:
                                                          const EdgeInsets.all(8),
                                                      decoration: BoxDecoration(
                                                          color: exitButtonFocus
                                                                  .hasFocus
                                                              ? Colors.orange
                                                              : Colors.black
                                                                  .withOpacity(
                                                                      0.9),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                      width: double.infinity,
                                                      child: const Text(
                                                        "Выйти",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16),
                                                      ))))),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    "Поддержка",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 22,
                                      color: Color(0xffd8d8d8),
                                    ),
                                  ),
                                  Container(
                                      margin: const EdgeInsets.all(8),
                                      padding: const EdgeInsets.all(10),
                                      width: double.infinity,
                                      child: Text(support,
                                          textAlign: TextAlign.start,
                                          style: const TextStyle(
                                              color: Color(0xffd8d8d8),
                                              fontSize: 18))),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          SizedBox(
                                              height: 32,
                                              child: SvgPicture.asset(
                                                  "assets/images/whatsapp.svg")),
                                          const Text("+44 7733 211034",
                                              style: TextStyle(
                                                  color: Color(0xffd8d8d8),
                                                  fontSize: 18))
                                        ]),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  ClickRemoteActionWidget(
                                    enter: (){
                                      showDialog(context: context, builder: (context)=>ChangePlayerPopup());
                                    },
                                      up: () {
                                        _changeFocus(exitButtonFocus);
                                      },
                                      child: Focus(
                                          focusNode: changeVPSButtonFocus,
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  primary: changeVPSButtonFocus
                                                          .hasFocus
                                                      ? Colors.orange
                                                      : Colors.black),
                                              onPressed: () {
                                              },
                                              child: Text("Текущий плеер: ${UserAccount.isVlc?"VLC":"Native"}"
                                                  .toUpperCase()))))
                                ],
                              ),
                            ))
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        margin: const EdgeInsets.only(
                            right: 8, left: 8, bottom: 8, top: 58),
                        decoration: BoxDecoration(
                            color: const Color(0xff23395d).withOpacity(0.7),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20))),
                        child: Column(
                          children: [
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                policy,
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.fade,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xffd8d8d8),
                                ),
                              ),
                            )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ))));
  }

  _changeFocus(FocusNode focusNode) {
    FocusScope.of(context).requestFocus(focusNode);
    setState(() {});
  }


}
