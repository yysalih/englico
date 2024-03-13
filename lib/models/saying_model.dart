import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'base_model.dart';

@JsonSerializable()
@immutable
class SayingModel implements BaseModel<SayingModel> {

  final String? uid;
  final String? image;
  final String? saying;
  final String? level;


  const SayingModel({this.uid, this.image, this.saying, this.level});

  @override
  SayingModel fromJson(Map<String, dynamic> json) =>
      SayingModel(
        uid: json['uid'] as String?,
        image: json['image'] as String?,
        saying: json['saying'] as String?,
        level: json['level'] as String?,
      );

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
    "uid" : uid,
    "image": image,
    "saying": saying,
    "level": level,
  };

}