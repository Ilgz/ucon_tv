import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_ucon/blocs/register/register_bloc.dart';
import 'package:new_ucon/views/register_otp_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:date_format/date_format.dart';
import '../utils/actionHandler.dart';

class RegScreen extends StatefulWidget {
  const RegScreen({Key? key}) : super(key: key);

  @override
  State<RegScreen> createState() => _RegScreenState();
}

class _RegScreenState extends State<RegScreen> {
  List<FocusNode> list=List.generate(11, (index) => FocusNode());
  String phoneNumber = "+996  ";
  List<String> digitList = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"];
  FocusNode submitButtonFocusNode = FocusNode();
  FocusNode vps3ButtonFocusNode = FocusNode();
  bool isFirst=true;
  @override
  Widget build(BuildContext context) {
    if (isFirst) {
      print(DateTime(2022, 12+1, 0).day);
      //print();
    //  BlocProvider.of<RegisterBloc>(context).add(LoginUser("phoneNumber", 2));
     // String day=formatDate(DateTime.now().toUtc().day,[dd]);
    //  print(.day);
      FocusScope.of(context).requestFocus(list[0]);
      isFirst=false;
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
                    "Введите номер мобильного телефона"
                              ,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w400)),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(5)),
                      width: _textSize(
                              "+996  709 872 197",
                              const TextStyle(fontSize: 24)) +
                          40,
                      padding:
                          const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: Text(phoneNumber,
                          style: const TextStyle(fontSize: 24)),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (int i = 0; i < list.length; i++) ...[
                            digitWidget(i),
                          ],
                          // digitWidget(0)
                        ]),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ClickRemoteActionWidget(
                          enter: () {

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegOtp()));
                          },
                          right: () {
                            _changeFocus(context, submitButtonFocusNode);
                          },
                          up: () {
                            _changeFocus(context, list[4]);
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
                                Text((" " * 10) + "VPS 2/3" + (" " * 8))),
                          ),
                        ),
                        SizedBox(width:10),
                        ClickRemoteActionWidget(
                          enter: () async{
                              if (phoneNumber.length == 17) {
                                print("phone");
                                print(phoneNumber.replaceAll("+", "").replaceAll(" ", ""));
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RegOtp(phoneNumber:phoneNumber.replaceAll("+", "").replaceAll(" ", ""))));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text("Заполните поле полностью")));
                              }
                          },
                          left: () {
                            _changeFocus(context, vps3ButtonFocusNode);
                          },
                          up: () {
                            _changeFocus(context, list[4]);
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
                                child: Text("${" " * 11}Далее${" " * 11}")),
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
          _changeFocus(context, vps3ButtonFocusNode);
        },
        right: () {
          if (index + 2 > list.length) {
            _changeFocus(context, list[0]);
          } else {
            _changeFocus(context, list[index + 1]);
          }
        },
        left: () {
          if (index == 0) {
            _changeFocus(context, list[list.length - 1]);
          } else {
            _changeFocus(context, list[index - 1]);
          }
        },
        enter: () {
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

        },
        child: index == 10
            ? Focus(
                focusNode: list[index],
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Icon(
                    Icons.backspace_outlined,
                    color: list[index].hasFocus
                        ? Colors.yellow.shade200
                        : Colors.black87,
                  ),
                ))
            : Focus(
                focusNode: list[index],
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    digitList[index],
                    style: TextStyle(
                        color: list[index].hasFocus
                            ? Colors.yellow.shade200
                            : Colors.black87,
                        fontSize: 24),
                  ),
                )));
  }

  _addDigit(String digit) {
      setState(() {
        if (phoneNumber.length < 17) {
          if (phoneNumber.length == 9 || phoneNumber.length == 13) {
            phoneNumber += " " + digit;
          } else {
            phoneNumber += digit;
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
