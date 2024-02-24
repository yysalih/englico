import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'base_model.dart';

@JsonSerializable()
@immutable
class TestModel implements BaseModel<TestModel> {

  final String? uid;
  final String? title;
  final String? description;

  const TestModel({this.description, this.uid, this.title});

  @override
  TestModel fromJson(Map<String, dynamic> json) =>
      TestModel(
        uid: json['uid'] as String?,
        title: json['title'] as String?,
        description: json['description'] as String?,
      );

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
    "uid" : uid,
    "title": title,
    "description": description,
  };

}