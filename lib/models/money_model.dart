import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'base_model.dart';

@JsonSerializable()
@immutable
class MoneyModel implements BaseModel<MoneyModel> {

  final String? uid;
  final String? name;
  final String? iban;
  final String? userId;
  final String? status;
  final double? amount;
  final int? date;


  const MoneyModel({this.uid, this.name, this.iban, this.amount, this.date, this.userId, this.status});

  @override
  MoneyModel fromJson(Map<String, dynamic> json) =>
      MoneyModel(
        uid: json['uid'] as String?,
        name: json['name'] as String?,
        iban: json['iban'] as String?,
        userId: json['userId'] as String?,
        status: json['status'] as String?,
        amount:  double.parse(json['amount'].toString()),
        date: json['date'] as int?,
      );

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
    "uid" : uid,
    "name": name,
    "iban": iban,
    "amount": amount,
    "date": date,
    "userId": userId,
    "status": status,
  };

}