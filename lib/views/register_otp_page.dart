import 'package:flutter/material.dart';
import 'package:new_ucon/views/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/actionHandler.dart';

class RegOtp extends StatefulWidget {
   RegOtp({Key? key,this.isThird=false}) : super(key: key);
   bool isThird;
  @override
  State<RegOtp> createState() => _RegOtpState();
}

class _RegOtpState extends State<RegOtp> {
  List<FocusNode>? list;
  String accessCode ="";
  List<String> digitList = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"];
  FocusNode submitButtonFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    if (list == null) {
      list = List.generate(11, (index) => FocusNode());
      FocusScope.of(context).requestFocus(list![0]);
      // FocusScope.of(context).requestFocus(submitButtonFocusNode);
    }
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: Image.asset('assets/images/background_reg.jpg').image,
            fit: BoxFit.cover),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: HandleRemoteActionsWidget(
            child: Container(
              margin: const EdgeInsets.only(right: 200, bottom: 100),
              alignment: Alignment.bottomRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                decoration: BoxDecoration(
                    color: Colors.white54,
                    borderRadius: BorderRadius.circular(5)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 20.0, bottom: 10),
                      child: Text("Авторизация",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w500)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30.0),
                      child: Text(
                              "Введите код для входа",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w400)),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(5)),
                      width: _textSize(
                           "228 777",
                          const TextStyle(fontSize: 24)) +
                          40,
                      padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: Text(accessCode.isEmpty?"000 000":accessCode,
                          style:  TextStyle(color:accessCode.isEmpty?Colors.grey:Colors.black,fontSize: 24)),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (int i = 0; i < list!.length; i++) ...[
                            digitWidget(i),
                          ],
                          // digitWidget(0)
                        ]),

                    ClickRemoteActionWidget(
                      enter: () async {
                          if (accessCode.length == 7) {
                            if(widget.isThird) {
                              if(accessCode=="867 174"){
                                final prefs =await  SharedPreferences.getInstance();
                                await prefs.setInt("server",3);
                                Navigator.pushAndRemoveUntil<dynamic>(
                                  context,
                                  MaterialPageRoute<dynamic>(
                                    builder: (context) => HomePage(),
                                  ),
                                      (route) => false, //if   you want to disable back feature set to false
                                );

                              }else{
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                        Text("Неправильный код")));
                              }

                            }else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomePage()));
                            }

                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                    Text("Заполните поле полностью")));
                          }
                      },
                      up: () {
                        _changeFocus(context, list![4]);
                      },
                      child: Focus(
                        focusNode: submitButtonFocusNode,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                onPrimary: submitButtonFocusNode.hasFocus
                                    ? Colors.yellow
                                    : Colors.black87),
                            onPressed: () {},
                            child: Text((" " * 11) + "Далее" + (" " * 11))),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }

  Widget digitWidget(int index) {
    return ClickRemoteActionWidget(
        one: () => _addDigit("1"),
        two: () => _addDigit("2"),
        three: () => _addDigit("3"),
        four: () => _addDigit("4"),
        five: () => _addDigit("5"),
        six: () => _addDigit("6"),
        seven: () => _addDigit("7"),
        eight: () => _addDigit("8"),
        nine: () => _addDigit("9"),
        zero: () => _addDigit("0"),
        down: () {
          _changeFocus(context, submitButtonFocusNode);
        },
        right: () {
          if (index + 2 > list!.length) {
            _changeFocus(context, list![0]);
          } else {
            _changeFocus(context, list![index + 1]);
          }
        },
        left: () {
          if (index == 0) {
            _changeFocus(context, list![list!.length - 1]);
          } else {
            _changeFocus(context, list![index - 1]);
          }
        },
        enter: () {
            if (index == 10) {
              if (accessCode.length >= 1) {
                setState(() {
                  accessCode = accessCode.substring(0, accessCode.length - 1);
                  if (accessCode.length != 0) {
                    if (accessCode[accessCode.length - 1] == " ") {
                      accessCode =
                          accessCode.substring(0, accessCode.length - 1);
                    }
                  }
                });
              }
            } else {
              setState(() {
                if (accessCode.length < 7) {
                  if (accessCode.length == 3) {
                    accessCode += " ${digitList[index]}";
                  } else {
                    accessCode += digitList[index];
                  }
                }
              });
          }
        },
        child: index == 10
            ? Focus(
            focusNode: list![index],
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Icon(
                Icons.backspace_outlined,
                color: list![index].hasFocus
                    ? Colors.yellow.shade200
                    : Colors.black87,
              ),
            ))
            : Focus(
            focusNode: list![index],
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Text(
                digitList[index],
                style: TextStyle(
                    color: list![index].hasFocus
                        ? Colors.yellow.shade200
                        : Colors.black87,
                    fontSize: 20),
              ),
            )));
  }

  _addDigit(String digit) {

      setState(() {
        if (accessCode.length < 7) {
          if (accessCode.length == 3) {
            accessCode += " " + digit;
          } else {
            accessCode += digit;
          }
        }
      });
  }

  _changeFocus(BuildContext context, FocusNode node) {
    FocusScope.of(context).requestFocus(node);
    setState(() {});
  }

  double _textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.width;
  }
}
