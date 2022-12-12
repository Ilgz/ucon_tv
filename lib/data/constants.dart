import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:new_ucon/utils/actionHandler.dart';

import '../models/movie_model.dart';
import '../models/producer_model.dart';
import '../models/slider_model.dart';

String myServer = "https://ucontv.com.kg/";
String rezkaServer = "https://rezka.ag/";


String support =
    "Не нашли нужный телеканал?\nУ вас есть пожелания?\nВозникли трудности с приложением?\nНапишите нам";

String policy ="Сервис UconTV Рад приветствовать Вас! Спасибо, что выбрали наш продукт! \n1) Расчетный период с 1-го по 1-ое число каждого календарного месяца.\n2) Стоимость подписки на 1 календарный месяц составляет 300 сом.\n3) В случае оплаты после даты обновления расчетного периода, то есть после 1-го числа календарного месяца Вам необходимо  оплатить полную сумму подписки, а в следующем месяце в случае оплаты до расчетного периода, оплачиваете сумму уже с перерасчетом исходя из даты оплаты предыдущего платежа.\n4) Система аккумулирует средства на балансе Пользователя. По истечение оплаченного периода пользования, при наличии необходимой суммы средств на балансе, подписка автоматически пролонгируется на следующий месяц со списанием соответствующей суммы с баланса.\n5) В случае неуплаты подписки, сервис блокируется для пользования. А в случае наличия на балансе пользователя средств то, средства будут списаны,и сервис будет доступен в тот день с которого средства остатка баланса покрывают подписку до конца расчетного периода.\n6) Сервис UconTV доступен Пользователю при условии доступа к сети любого провайдера услуг Интернет.\n7) Если вы используете подписку привязанную к вашему лицевому счету от вашего провайдера, то вышеизложенная информация для вас неакутальна.\n8) Сервис доступен на трех абонентских устройствах принадлежащих Пользователю.\n9) Сервис UconTV не несет ответственности за транслируемый и размещенный контент.\n10) Сервис UconTV не дает никаких явных или подразумеваемых гарантий, заявлений, подтверждений ответственности за транслируемый контент, ущерб или упущенную прибыль, потерю бизнеса и т.д. явно или косвенно связанную с данным сервисом.\n11) UconTV работает в автономном режиме и действует в соответствии с законом Кыргызской Республики о защите авторских прав и информации, а также полностью его поддерживает.\n12) Весь контент размещаемый в приложении, является общедоступной для просмотра и скачивания в сети Интернет и в других ресурсах. Сбор и трансляция контента из сети Интернет и других источников  в приложении производится автоматически. Администрация не контролирует материал, который добавляется и транслируется в контенте приложения. Также администрация ни в коем случае не занимается публикацией нелицензионного или краденного контента, находящегося под защитой настоящего правооблодателя. Автоматизированная система публикует только тот материал, который находится в сети Интернет или в других ресурсах в свободном доступе, при этом пользуясь только открытыми источниками!\n13) Если в приложении были нарушены Ваши авторские права, администрация с радостью окажет Вам содействие и удалит контент, официально принадлежащий Вам.Администрация всегда идет на встречу настоящим правооблодателям! Для этого напишите нам на почту по адресу tvucon@gmail.com\nВАЖНО! В письме обязательно необходимо указать:\n1) Точное название контента на размещение которого в нашем ресурсе у Вас есть претензии.\n2) Сканкопия документов удостоверящие вашу личность.\n3) Сканкопия юридических документов подтверждающие ваши права правооблодателя на претензионный контент.Без указания всех требуемых нами данных Ваше письмо будет проигнорировано!\nПриятного пользования!"
;
RegExp regExpLink = RegExp(
    r"((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?");


class UserAccount{
  static bool hasAccess=true;
  static String phoneNumber ="";
  static String balance ="";
  static int server =1;
  static bool isVlc=true;
}
class HomeClass {
  static bool isLoadingNewElements=false;
  static String recommendationLink="";
  static List<SliderModel> sliderList = [];
  static ScrollController pageController = ScrollController();
  static int channelIndex=0;
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
class SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight
    extends SliverGridDelegate {
  /// Creates a delegate that makes grid layouts with a fixed number of tiles in
  /// the cross axis.
  ///
  /// All of the arguments must not be null. The `mainAxisSpacing` and
  /// `crossAxisSpacing` arguments must not be negative. The `crossAxisCount`
  /// and `childAspectRatio` arguments must be greater than zero.
  const SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight({
    required this.crossAxisCount,
    this.mainAxisSpacing = 0.0,
    this.crossAxisSpacing = 0.0,
    this.height = 56.0,
  })  : assert(crossAxisCount != null && crossAxisCount > 0),
        assert(mainAxisSpacing != null && mainAxisSpacing >= 0),
        assert(crossAxisSpacing != null && crossAxisSpacing >= 0),
        assert(height != null && height > 0);

  /// The number of children in the cross axis.
  final int crossAxisCount;

  /// The number of logical pixels between each child along the main axis.
  final double mainAxisSpacing;

  /// The number of logical pixels between each child along the cross axis.
  final double crossAxisSpacing;

  /// The height of the crossAxis.
  final double height;

  bool _debugAssertIsValid() {
    assert(crossAxisCount > 0);
    assert(mainAxisSpacing >= 0.0);
    assert(crossAxisSpacing >= 0.0);
    assert(height > 0.0);
    return true;
  }

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    assert(_debugAssertIsValid());
    final double usableCrossAxisExtent =
        constraints.crossAxisExtent - crossAxisSpacing * (crossAxisCount - 1);
    final double childCrossAxisExtent = usableCrossAxisExtent / crossAxisCount;
    final double childMainAxisExtent = height;
    return SliverGridRegularTileLayout(
      crossAxisCount: crossAxisCount,
      mainAxisStride: childMainAxisExtent + mainAxisSpacing,
      crossAxisStride: childCrossAxisExtent + crossAxisSpacing,
      childMainAxisExtent: childMainAxisExtent,
      childCrossAxisExtent: childCrossAxisExtent,
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
    );
  }

  @override
  bool shouldRelayout(
      SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight oldDelegate) {
    return oldDelegate.crossAxisCount != crossAxisCount ||
        oldDelegate.mainAxisSpacing != mainAxisSpacing ||
        oldDelegate.crossAxisSpacing != crossAxisSpacing ||
        oldDelegate.height != height;
  }
}

