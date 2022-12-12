// To parse this JSON data, do
//
//     final userData = userDataFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<UserData> userDataFromJson(String str) => List<UserData>.from(json.decode(str).map((x) => UserData.fromJson(x)));

String userDataToJson(List<UserData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserData {
  UserData({
    required this.phoneNumber,
    required this.balance,
    required this.payedMonth,
    required this.model1,
    required this.model2,
    required this.model3,
    required this.model4,
    required this.fio,
  });

  String phoneNumber;
  String balance;
  String payedMonth;
  dynamic model1;
  dynamic model2;
  dynamic model3;
  dynamic model4;
  String? fio;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    phoneNumber: json["phone_number"],
    balance: json["balance"],
    payedMonth: json["payed_month"],
    model1: json["Model 1"],
    model2: json["Model 2"],
    model3: json["Model 3"],
    model4: json["Model 4"],
    fio: json["FIO"],
  );

  Map<String, dynamic> toJson() => {
    "phone_number": phoneNumber,
    "balance": balance,
    "payed_month": payedMonth,
    "Model 1": model1,
    "Model 2": model2,
    "Model 3": model3,
    "Model 4": model4,
    "FIO": fio,
  };
}
