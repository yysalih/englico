import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'base_model.dart';

@JsonSerializable()
@immutable
class WordModel implements BaseModel<WordModel> {

  final String? uid;
  final String? english;
  final String? englishSentence;
  final String? turkishSentence;
  final String? submeaning;
  final String? turkish;
  final String? level;

  const WordModel({
    this.turkish, this.uid,
    this.english, this.level,
    this.submeaning, this.turkishSentence, this.englishSentence,
  });

  @override
  WordModel fromJson(Map<String, dynamic> json) =>
      WordModel(
        uid: json['uid'] as String?,
        english: json['english'] as String?,
        turkish: json['turkish'] as String?,
        level: json['level'] as String?,
        submeaning: json['submeaning'] as String?,
        turkishSentence: json['turkishSentence'] as String?,
        englishSentence: json['englishSentence'] as String?,
      );

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
    "uid" : uid,
    "english": english,
    "turkish": turkish,
    "level": level,
    "turkishSentence": turkishSentence,
    "englishSentence": englishSentence,
    "submeaning": submeaning,
  };

}