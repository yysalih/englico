import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import '../base_model.dart';

@JsonSerializable()
@immutable
class WordMatchModel implements BaseModel<WordMatchModel> {

  final String? type;
  final Map<String, dynamic>? words;
  final Map<String, dynamic>? shuffledWords;

  const WordMatchModel({this.type = "word_match", this.words, this.shuffledWords});



  @override
  WordMatchModel fromJson(Map<String, dynamic> json) =>
      WordMatchModel(
        type: json['type'] as String?,
        words: json['words'] as Map<String, dynamic>?,
      );


  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
    "type" : type,
    "words": words,
  };

}