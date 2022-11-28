import 'package:flutter/material.dart';
import 'package:new_ucon/views/register_otp_page.dart';

import '../utils/actionHandler.dart';

class RegScreen extends StatefulWidget {
  const RegScreen({Key? key}) : super(key: key);

  @override
  State<RegScreen> createState() => _RegScreenState();
}

class _RegScreenState extends State<RegScreen> {
  List<FocusNode>? list;
  String phoneNumber = "+996  ";
  String billNumber = "";
  List<String> digitList = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"];
  FocusNode submitButtonFocusNode = FocusNode();
  FocusNode vps3ButtonFocusNode = FocusNode();
  late FocusNode changeModeButtonFocusNode;
  int mode = 0;

  @override
  Widget build(BuildContext context) {
    if (list == null) {
      list = List.generate(11, (index) => FocusNode());
      changeModeButtonFocusNode = FocusNode();
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
              margin: const EdgeInsets.only(right: 100, bottom: 100),
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
                          mode == 0
                              ? "Введите номер мобильного телефона"
                              : "Введите номер лицевого счета",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w400)),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(5)),
                      width: _textSize(
                              mode == 0 ? "+996  709 872 197" : "228 777",
                              const TextStyle(fontSize: 24)) +
                          40,
                      padding:
                          const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: Text(mode == 0 ? phoneNumber : billNumber,
                          style: const TextStyle(fontSize: 24)),
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
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ClickRemoteActionWidget(
                          enter: () {
                            mode = mode == 0 ? 1 : 0;
                            setState(() {});
                          },
                          right: () {
                            _changeFocus(context, vps3ButtonFocusNode);
                          },
                          up: () {
                            _changeFocus(context, list![4]);
                          },
                          child: Focus(
                            focusNode: changeModeButtonFocusNode,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.white,
                                    onPrimary:
                                        changeModeButtonFocusNode.hasFocus
                                            ? Colors.yellow
                                            : Colors.black87),
                                onPressed: () {},
                                child:
                                    Text((" " * 10) + "Сменить" + (" " * 10))),
                          ),
                        ),
                        SizedBox(width:10),
                        ClickRemoteActionWidget(
                          enter: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegOtp(isThird: true,)));
                          },
                          right: () {
                            _changeFocus(context, submitButtonFocusNode);
                          },
                          left: (){
                            _changeFocus(context, changeModeButtonFocusNode);
                          },
                          up: () {
                            _changeFocus(context, list![4]);
                          },
                          child: Focus(
                            focusNode: vps3ButtonFocusNode,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.white,
                                    onPrimary:
                                    vps3ButtonFocusNode.hasFocus
                                        ? Colors.yellow
                                        : Colors.black87),
                                onPressed: () {},
                                child:
                                Text((" " * 10) + "VPS 3" + (" " * 10))),
                          ),
                        ),
                        SizedBox(width:10),
                        ClickRemoteActionWidget(
                          enter: () {
                            if (mode == 0) {
                              if (phoneNumber.length == 17) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RegOtp()));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text("Заполните поле полностью")));
                              }
                            } else {
                              if (phoneNumber.length == 7) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>  RegOtp()));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text("Заполните поле полностью")));
                              }
                            }
                          },
                          left: () {
                            _changeFocus(context, vps3ButtonFocusNode);
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
                        ),
                      ],
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
          _changeFocus(context, changeModeButtonFocusNode);
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
          if (mode == 0) {
            if (index == 10) {
              if (phoneNumber.length > 6) {
                setState(() {
                  phoneNumber =
                      phoneNumber.substring(0, phoneNumber.length - 1);
                  if (phoneNumber[phoneNumber.length - 1] == " ") {
                    if (phoneNumber != "+996  ") {
                      phoneNumber =
                          phoneNumber.substring(0, phoneNumber.length - 1);
                    }
                  }
                });
              }
            } else {
              setState(() {
                if (phoneNumber.length < 17) {
                  if (phoneNumber.length == 9 || phoneNumber.length == 13) {
                    phoneNumber += " ${digitList[index]}";
                  } else {
                    phoneNumber += digitList[index];
                  }
                }
              });
            }
          } else {
            if (index == 10) {
              if (billNumber.length >= 1) {
                setState(() {
                  billNumber = billNumber.substring(0, billNumber.length - 1);
                  if (billNumber.length != 0) {
                    if (billNumber[billNumber.length - 1] == " ") {
                      billNumber =
                          billNumber.substring(0, billNumber.length - 1);
                    }
                  }
                });
              }
            } else {
              setState(() {
                if (billNumber.length < 7) {
                  if (billNumber.length == 3) {
                    billNumber += " ${digitList[index]}";
                  } else {
                    billNumber += digitList[index];
                  }
                }
              });
            }
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
    if (mode == 0) {
      setState(() {
        if (phoneNumber.length < 17) {
          if (phoneNumber.length == 9 || phoneNumber.length == 13) {
            phoneNumber += " " + digit;
          } else {
            phoneNumber += digit;
          }
        }
      });
    } else {
      setState(() {
        if (billNumber.length < 7) {
          if (billNumber.length == 3) {
            billNumber += " " + digit;
          } else {
            billNumber += digit;
          }
        }
      });
    }
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
