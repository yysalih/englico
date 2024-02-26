import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TestState {
  final int activeQuestionIndex;

  TestState({required this.activeQuestionIndex});

  TestState copyWith({
    int? activeQuestionIndex
  }) {
    return TestState(
      activeQuestionIndex: activeQuestionIndex ?? this.activeQuestionIndex
    );
  }
}

class TestController extends StateNotifier<TestState> {
  TestController(super.state);

  changeActiveQuestion(int index) {
    state = state.copyWith(activeQuestionIndex: index);
  }
}

final testController = StateNotifierProvider<TestController, TestState>((ref) =>
  TestController(
    TestState(
      activeQuestionIndex: 0
    )
  )
);