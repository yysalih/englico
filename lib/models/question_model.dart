import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'base_model.dart';

@JsonSerializable()
@immutable
class QuestionModel implements BaseModel<QuestionModel> {

  final String? uid;
  final String? title;
  final String? description;
  final Map<String, dynamic>? question;
  final String? type;
  final int? point;

  const QuestionModel({
    this.description, this.uid, this.title,
    this.question, this.type, this.point,
  });

  @override
  QuestionModel fromJson(Map<String, dynamic> json) =>
      QuestionModel(
        uid: json['uid'] as String?,
        title: json['title'] as String?,
        description: json['description'] as String?,
        point: json['point'] as int?,
        type: json['type'] as String?,
        question: json['question'] as Map<String, dynamic>?,
      );

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
    "uid" : uid,
    "title": title,
    "description": description,
    "question": question,
    "type": type,
    "point": point,
  };

}