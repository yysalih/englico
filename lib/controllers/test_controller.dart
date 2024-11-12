import 'package:englico/controllers/user_controller.dart';
import 'package:englico/models/content_model.dart';
import 'package:englico/models/question_models/word_match_model.dart';
import 'package:englico/models/user_model.dart';
import 'package:englico/utils/contants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/question_model.dart';
import '../models/test_model.dart';

class TestState {
  final int activeQuestionIndex;
  final bool isAnswered;
  final int point;
  final String key;
  final String value;
  final Color selectedKeyColor;
  final Color selectedValueColor;
  final List correctKeys;
  final List correctValues;

  final List keys;
  final List values;

  final bool isShuffled;

  TestState({
    required this.key,
    required this.correctValues,
    required this.correctKeys,
    required this.selectedKeyColor,
    required this.selectedValueColor,
    required this.value,
    required this.activeQuestionIndex,
    required this.isAnswered,
    required this.point,
    required this.keys,
    required this.values,
    required this.isShuffled,
  });

  TestState copyWith({
    int? activeQuestionIndex,
    bool? isAnswered,
    bool? isShuffled,
    int? point,
    String? key,
    String? value,
    Color? selectedKeyColor,
    Color? selectedValueColor,
    List? correctValues,
    List? correctKeys,
    List? keys,
    List? values,
  }) {
    return TestState(
      selectedKeyColor: selectedKeyColor ?? this.selectedKeyColor,
      selectedValueColor: selectedValueColor ?? this.selectedValueColor,
      value: value ?? this.value,
      key: key ?? this.key,
      activeQuestionIndex: activeQuestionIndex ?? this.activeQuestionIndex,
        isAnswered: isAnswered ?? this.isAnswered,
      point: point ?? this.point,
      correctKeys: correctKeys ?? this.correctKeys,
      correctValues: correctValues ?? this.correctValues,
      keys: keys ?? this.keys,
      values: values ?? this.values,
      isShuffled: isShuffled ?? this.isShuffled,
    );
  }
}

class TestController extends StateNotifier<TestState> {
  TestController(super.state);

  changeActiveQuestion(int index) {
    state = state.copyWith(activeQuestionIndex: index);
  }
  changeIsAnswered({required bool value}) {
    state = state.copyWith(isAnswered: value);
  }
  changePoint({required int value}) {
    state = state.copyWith(point: value);
  }

  List wordMatchKeysAndValues(WordMatchModel wordMatchModel, {bool isKeys = true}) {
    if(isKeys) {
      List keys = wordMatchModel.words!.keys.toList();
      keys.shuffle();
      return keys;
    }
    else {
      List values = wordMatchModel.words!.values.toList();
      values.shuffle();
      return values;
    }
  }

  changeKeyOrValue(String value, {bool isKey = true}) {
    if(isKey) {
      state = state.copyWith(key: value);
    }
    else {
      state = state.copyWith(value: value);

    }
    changeSelectedColor(Constants.kSecondColor, isKey: isKey);

  }

  changeSelectedColor(Color value, {bool isKey = true}) {
    if(isKey) {
      state = state.copyWith(selectedKeyColor: value);
    }
    else {
      state = state.copyWith(selectedValueColor: value);

    }
  }

  resetAll() {
    state = state.copyWith(
      key: "", value: "", selectedKeyColor: Colors.white, selectedValueColor: Colors.white,
      isShuffled: false, values: [], keys: [],

    );
  }

  addInCorrectedKeysValues(String value, {bool isKey = true, bool removeAll = false}) {
    if(!removeAll) {
      if(isKey) {
        state = state.copyWith(correctKeys: state.correctKeys..add(value));
      }
      else {
        state = state.copyWith(correctValues: state.correctValues..add(value));
      }
    }
    else {
      state = state.copyWith(correctKeys: [], correctValues: []);

    }

  }

  continueButton({
    required List<QuestionModel> allQuestions,
    required UserModel user,
    required List<TestModel> tests,
    required UserController userWatch,
    required List<ContentModel> contents,
  }) {
    if(state.activeQuestionIndex+1 < allQuestions.length) {
      changeActiveQuestion(state.activeQuestionIndex+1);
      changeIsAnswered(value: false);
    }
    else if(state.activeQuestionIndex+1 == allQuestions.length) {

      userWatch.addInUserTests(user, tests.first.uid!);

      debugPrint("Tests Length: ${tests.length}");

      if(tests.length == 1) {
        if(user.point! >= contents.first.point!) {
          userWatch.addInUserContents(user, contents.first.uid!);
        }
      }

      else {
        changeActiveQuestion(0);
        changeIsAnswered(value: false);
      }
    }

    addInCorrectedKeysValues("", isKey: false, removeAll: true);

  }

  updateKeysAndValues({required WordMatchModel wordMatchModel}) {
    state = state.copyWith(
      keys: wordMatchModel.words!.keys.toList().where((element) => !state.correctKeys.contains(element)).toList(),
      values: wordMatchModel.words!.values.toList().where((element) => !state.correctValues.contains(element)).toList()
    );
  }

  changeIsShuffled({required bool value}) {
    state = state.copyWith(isShuffled: value);
  }
}

final testController = StateNotifierProvider<TestController, TestState>((ref) =>
  TestController(
    TestState(
      value: "", key: "",
      correctKeys: [], correctValues: [],
      activeQuestionIndex: 0,
      isAnswered: false,
      point: 0,
      selectedKeyColor: Colors.white,
      selectedValueColor: Colors.white,
      keys: [], values: [], isShuffled: false
    )
  )
);