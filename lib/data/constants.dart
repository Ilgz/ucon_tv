import 'package:flutter/material.dart';
import 'package:new_ucon/utils/actionHandler.dart';

import '../models/movie_model.dart';
import '../models/producer_model.dart';
import '../models/slider_model.dart';

String myServer = "https://ucontv.com.kg/";
String rezkaServer = "https://rezka.ag/";


String support =
    "Не нашли нужный телеканал?\nУ вас есть пожелания?\nВозникли трудности с приложением?\nНапишите нам";
String policy =
    "Сервис UconTV это оптимизированная на рынок Кыргызстана версия популярного в Российской Федерации платформы TV-Boom. Спасибо, что выбрали наш продукт!\n\n 1)	Расчетный период с 1-го по 1-ое число каждого календарного месяца.\n 2)	Стоимость подписки на 1 календарный месяц составляет 200 сом.\n 3)	Биллинг система UconTV при подключении подписки настроена списывать с баланса Пользователя только по 200 сомов за каждый месяц. \n 4)	В случае оплаты после даты обновления расчетного периода, то есть после 1-го числа календарного месяца вам всё равно нужно оплатить 200 сомов, а последующий месяц уже оплачиваете с перерасчетом исходя из даты оплаты предыдущего платежа. \n 5)	Система аккумулирует средства на балансе Пользователя. По истечение оплаченного периода пользования, при наличии необходимой суммы средств на балансе, подписка автоматически пролонгируется на следующий месяц со списанием соответствующей суммы с баланса.\n 6)	В случае неуплаты подписки, сервис блокируется для пользования. А в случае наличия на балансе пользователя средств то, средства будут списаны, а сервис будет доступен в тот день с которого средства остатка баланса покрывают подписку до конца расчетного периода. \n 7)	Сервис доступен на трех абонентских устройствах принадлежащих Пользователю.\n 8)	Сервис UconTV доступен Пользователю при условии доступа к сети любого провайдера услуг Интернет.\n 9)	Сервис UconTV не несет ответственности за транслируемый контент.  \n 10)	Сервис UconTV не дает никаких явных или подразумеваемых гарантий, заявлений, подтверждений ответственности за транслируемый контент, ущерб или упущенную прибыль, потерю бизнеса и т.д. явно или косвенно связанную с данным сервисом.\n\n Приятного пользования!";
RegExp regExpLink = RegExp(
    r"((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?");

class MoviePlayClass {
  static late  FocusNode seekBarFocus;
}

class HomeClass {
  static bool isLoadingNewElements=false;
  static List<SliderModel> sliderList = [];
  static ScrollController pageController = ScrollController();
  static int channelIndex=0;
  static  FocusNode sliderFocus=FocusNode();
  static List<MovieElement> movieElements = [
    MovieElement(sectionIndex: 0, sectionName: 'Премьеры'),
    MovieElement(sectionName: "Мультфильмы", sectionIndex: 1),
    MovieElement(sectionName: "Сериалы", sectionIndex: 2),
  ];
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


