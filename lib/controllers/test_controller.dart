import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TestState {
  final int activeQuestionIndex;
  final bool isAnswered;
  final int point;

  TestState({
    required this.activeQuestionIndex,
    required this.isAnswered,
    required this.point,
  });

  TestState copyWith({
    int? activeQuestionIndex,
    bool? isAnswered,
    int? point,
  }) {
    return TestState(
      activeQuestionIndex: activeQuestionIndex ?? this.activeQuestionIndex,
        isAnswered: isAnswered ?? this.isAnswered,
      point: point ?? this.point,
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
}

final testController = StateNotifierProvider<TestController, TestState>((ref) =>
  TestController(
    TestState(
      activeQuestionIndex: 0,
      isAnswered: false,
      point: 0
    )
  )
);