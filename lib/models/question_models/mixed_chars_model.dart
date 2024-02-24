import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import '../base_model.dart';

@JsonSerializable()
@immutable
class MixedCharsModel implements BaseModel<MixedCharsModel> {
  
  final String? type;
  final String? questionText;
  final String? answer;
  final List? answers;

  const MixedCharsModel({
    this.type = "mixed_chars",
    this.questionText,
    this.answer,
    this.answers,
  });

  @override
  MixedCharsModel fromJson(Map<String, dynamic> json) =>
      MixedCharsModel(
        type: json['type'] as String?,
        questionText: json['question_text'] as String?,
        answer: json['answer'] as String?,
        answers: json['answers'] as List?,
      );

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
    "type" : type,
    "question_text" : questionText,
    "answer" : answer,
    "answers": answers,
  };

}