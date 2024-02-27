import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TestState {
  final int activeQuestionIndex;
  final bool isAnswered;

  TestState({
    required this.activeQuestionIndex,
    required this.isAnswered
  });

  TestState copyWith({
    int? activeQuestionIndex,
    bool? isAnswered,
  }) {
    return TestState(
      activeQuestionIndex: activeQuestionIndex ?? this.activeQuestionIndex,
        isAnswered: isAnswered ?? this.isAnswered
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
}

final testController = StateNotifierProvider<TestController, TestState>((ref) =>
  TestController(
    TestState(
      activeQuestionIndex: 0,
      isAnswered: false
    )
  )
);