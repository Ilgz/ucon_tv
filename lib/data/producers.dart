import 'package:new_ucon/models/producer_model.dart';

class ProducerClass {
  String sectionName;

  ProducerClass(this.sectionName);

  List<Producer> cartoonProducers() {
    return [ newbie(),disney(), netflix(), others()];
  }

  List<Producer> movieProducers() {
    return [
      newbie(),
      amazon(),
      appleTV(),
      netflix(),
      hbo(),
      disney(),
      others()
    ];
  }

  List<Producer> categories() {
    return [
      categoryFamily(),
      categoryHorror(),
      categoryAction(),
      categoryComedy(),
      categoryDocumentary(),
      categoryThriller(),
      categoryAdventure(),
      categoryDetective()
    ];
  }

  Producer categoryDocumentary() {
    return Producer(
        name: "Документальные",
        imageName: "",
        link: sectionName == "Премьеры"
            ? "films/documentary"
            : (sectionName == "Сериалы"
            ? "series/documentary"
            : "cartoons/documentary"));
  }

  Producer categoryAction() {
    return Producer(
        name: "Боевики",
        imageName: "",
        link: sectionName == "Премьеры"
            ? "films/action"
            : (sectionName == "Сериалы" ? "series/action" : "cartoons/action"));
  }

  Producer categoryHorror() {
    return Producer(
        name: "Ужасы",
        imageName: "",
        link: sectionName == "Премьеры"
            ? "films/horror"
            : (sectionName == "Сериалы" ? "series/horror" : "cartoons/horror"));
  }

  Producer categoryThriller() {
    return Producer(
        name: "Триллеры",
        imageName: "",
        link: sectionName == "Премьеры"
            ? "films/thriller"
            : (sectionName == "Сериалы"
            ? "series/thriller"
            : "cartoons/thriller"));
  }

  Producer categoryAdventure() {
    return Producer(
        name: "Приключения",
        imageName: "",
        link: sectionName == "Премьеры"
            ? "films/adventures"
            : (sectionName == "Сериалы"
            ? "series/adventures"
            : "cartoons/adventures"));
  }

  Producer categoryFamily() {
    return Producer(
        name: "Семейные",
        imageName: "",
        link: sectionName == "Премьеры"
            ? "films/family"
            : (sectionName == "Сериалы" ? "series/family" : "cartoons/family"));
  }

  Producer categoryDetective() {
    return Producer(
        name: "Детективы",
        imageName: "",
        link: sectionName == "Премьеры"
            ? "films/detective"
            : (sectionName == "Сериалы"
            ? "series/detective"
            : "cartoons/detective"));
  }

  Producer categoryComedy() {
    return Producer(
        name: "Комедии",
        imageName: "",
        link: sectionName == "Премьеры"
            ? "films/comedy"
            : (sectionName == "Сериалы" ? "series/comedy" : "cartoons/comedy"));
  }

  Producer appleTV() {
    return Producer(
        name: "Apple TV",
        imageName: "apple_tv",
        link: sectionName == "Премьеры"
            ? "collections/1416-filmy-apple-tv"
            : "collections/1146-serialy-apple-tv");
  }

  Producer amazon() {
    return Producer(
        name: "Амазон",
        imageName: "amazon",
        link: sectionName == "Премьеры"
            ? "collections/1417-filmy-amazon"
            : "collections/831-serialy-amazon");
  }

  Producer hbo() {
    return Producer(
        name: "HBO",
        imageName: "hbo",
        link: sectionName == "Премьеры"
            ? "collections/1419-filmy-hbo"
            : "collections/639-serialy-hbo");
  }

  Producer disney() {
    return Producer(
        name: "Дисней",
        imageName: "disney",
        link: sectionName == "Премьеры"
            ? "collections/1075-filmy-disney"
            : (sectionName == "Сериалы"
            ? "1148-serialy-disney"
            : "collections/1-multfilmy-disney"));
  }

  Producer netflix() {
    return Producer(
        name: "Нетфликс",
        imageName: "netflix",
        link: sectionName == "Премьеры"
            ? "collections/834-filmy-netflix"
            : (sectionName == "Сериалы"
            ? "collections/640-serialy-netflix"
            : "collections/1004-animacionnye-serialy-netflix"));
  }

  Producer newbie() {
    return Producer(
        name: "Новинки",
        imageName: "newbie",
        link: sectionName == "Премьеры"
            ? "films/best/2022"
            : (sectionName == "Сериалы"
            ? "series/best/2022"
            : "cartoons/best/2022"));
  }

  Producer others() {
    return Producer(
        name: "Другие Премьеры",
        imageName: "others",
        link: sectionName == "Премьеры"
            ? "films"
            : (sectionName == "Сериалы" ? "series" : "cartoons"));
  }
}