import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import '../base_model.dart';

@JsonSerializable()
@immutable
class CompleteSentenceModel implements BaseModel<CompleteSentenceModel> {

  final String? type;
  final String? correctSentence;
  final String? uncompletedSentence;
  final String? answer;
  final List? words;
  final List? answers;

  const CompleteSentenceModel({
    this.type = "complete_sentence", this.words,
    this.correctSentence, this.uncompletedSentence,
    this.answer, this.answers,
  });

  @override
  CompleteSentenceModel fromJson(Map<String, dynamic> json) =>
      CompleteSentenceModel(
        type: json['type'] as String?,
        words: json['words'] as List?,
        correctSentence: json['correct_sentence'] as String?,
        uncompletedSentence: json['uncompleted_sentence'] as String?,
        answer: json['answer'] as String?,
        answers: json['answers'] as List?,
      );

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
    "type" : type,
    "words": words,
    "correct_sentence" : correctSentence,
    "uncompleted_sentence": uncompletedSentence,
    "answer" : answer,
    "answers": answers,
  };

}