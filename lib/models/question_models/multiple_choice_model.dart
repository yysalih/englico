import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import '../base_model.dart';

@JsonSerializable()
@immutable
class MultipleChoiceModel implements BaseModel<MultipleChoiceModel> {
  
  final String? type;
  final String? questionText;
  final String? answer;
  final List? answers;

  const MultipleChoiceModel({
    this.type = "multiple_choice",
    this.questionText,
    this.answer,
    this.answers,
  });

  @override
  MultipleChoiceModel fromJson(Map<String, dynamic> json) =>
      MultipleChoiceModel(
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