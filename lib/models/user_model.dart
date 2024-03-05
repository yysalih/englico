import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'base_model.dart';

@JsonSerializable()
@immutable
class UserModel implements BaseModel<UserModel> {

  final String? uid;
  final String? name;
  final String? image;
  final String? email;
  final String? token;
  final int? point;
  final int? subscriptionDate;
  final List? words;
  final List? savedWords;
  final List? tests;
  final List? contents;

  UserModel({this.uid, this.name, this.image,
    this.subscriptionDate, this.words, this.tests,
    this.email, this.token, this.point, this.contents,
    this.savedWords
  });

  @override
  UserModel fromJson(Map<String, dynamic> json) => UserModel(
    token: json["token"] as String?,
    image: json["image"] as String?,
    uid: json["uid"] as String?,
    name: json["name"] as String?,
    email: json["email"] as String?,
    point: json["point"] as int?,
    subscriptionDate: json["subscriptionDate"] as int?,
    words: json["words"] as List?,
    tests: json["tests"] as List?,
    contents: json["contents"] as List?,
    savedWords: json["saved_words"] as List?,
  );

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
    "token": token,
    "image": image,
    "uid": uid,
    "name": name,
    "email": email,
    "point": point,
    "subscriptionDate": subscriptionDate,
    "words": words,
    "tests": tests,
    "contents": contents,
    "savedWords": savedWords,
  };

}