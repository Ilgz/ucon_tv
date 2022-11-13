import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:new_ucon/utils/actionHandler.dart';

import 'model/film.dart';
import 'model/movie_element.dart';

String myServer = "https://ucontv.com.kg/";
String rezkaServer="https://rezka.ag/";
String support =
    "Не нашли нужный телеканал?\nУ вас есть пожелания?\nВозникли трудности с приложением?\nНапишите нам";
String policy =
    "Сервис UconTV это оптимизированная на рынок Кыргызстана версия популярного в Российской Федерации платформы TV-Boom. Спасибо, что выбрали наш продукт!\n\n 1)	Расчетный период с 1-го по 1-ое число каждого календарного месяца.\n 2)	Стоимость подписки на 1 календарный месяц составляет 200 сом.\n 3)	Биллинг система UconTV при подключении подписки настроена списывать с баланса Пользователя только по 200 сомов за каждый месяц. \n 4)	В случае оплаты после даты обновления расчетного периода, то есть после 1-го числа календарного месяца вам всё равно нужно оплатить 200 сомов, а последующий месяц уже оплачиваете с перерасчетом исходя из даты оплаты предыдущего платежа. \n 5)	Система аккумулирует средства на балансе Пользователя. По истечение оплаченного периода пользования, при наличии необходимой суммы средств на балансе, подписка автоматически пролонгируется на следующий месяц со списанием соответствующей суммы с баланса.\n 6)	В случае неуплаты подписки, сервис блокируется для пользования. А в случае наличия на балансе пользователя средств то, средства будут списаны, а сервис будет доступен в тот день с которого средства остатка баланса покрывают подписку до конца расчетного периода. \n 7)	Сервис доступен на трех абонентских устройствах принадлежащих Пользователю.\n 8)	Сервис UconTV доступен Пользователю при условии доступа к сети любого провайдера услуг Интернет.\n 9)	Сервис UconTV не несет ответственности за транслируемый контент.  \n 10)	Сервис UconTV не дает никаких явных или подразумеваемых гарантий, заявлений, подтверждений ответственности за транслируемый контент, ущерб или упущенную прибыль, потерю бизнеса и т.д. явно или косвенно связанную с данным сервисом.\n\n Приятного пользования!";
RegExp regExpLink = RegExp(
    r"((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?");
class MoviePlayClass{
  static FocusNode seekBarFocus=FocusNode();
}
class HomeClass {
  static FocusNode searchFocus = FocusNode();
  static FocusNode profileFocus = FocusNode();
  static FocusNode sliderFocusNode=FocusNode();
  static CarouselController carouselController=CarouselController();
  static List<MovieElement> movieElements=[MovieElement(sectionIndex:0, sectionName: 'Премьеры'),MovieElement(sectionName: "Мультфильмы", sectionIndex: 1),MovieElement(sectionName: "Сериалы", sectionIndex: 2),MovieElement(sectionName: "Фильмы", sectionIndex: 3),];
  static int activeIndex = 0;
}



double TextSize(String text, TextStyle style) {
  final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr)
    ..layout(minWidth: 0, maxWidth: double.infinity);
  return textPainter.height;
}

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
