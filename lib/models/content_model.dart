import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'base_model.dart';

@JsonSerializable()
@immutable
class ContentModel implements BaseModel<ContentModel> {

  final String? uid;
  final String? image;
  final String? title;
  final String? description;
  final int? point;

  ContentModel({this.description, this.point, this.uid, this.image, this.title});

  @override
  ContentModel fromJson(Map<String, dynamic> json) =>
      ContentModel(
        uid: json['uid'] as String?,
        image: json['image'] as String?,
        title: json['title'] as String?,
        description: json['description'] as String?,
        point: json['point'] as int?,
      );

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
    "uid" : uid,
    "image": image,
    "title": title,
    "description": description,
    "point": point,
  };

}