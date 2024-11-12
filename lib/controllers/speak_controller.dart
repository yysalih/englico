import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeakState {
  final bool speechEnabled;
  final bool isCorrect;
  final String lastWords;
  final String currentWord;

  SpeakState({required this.speechEnabled,
    required this.lastWords,
    required this.isCorrect,
    required this.currentWord,
  });

  SpeakState copyWith({
    bool? speechEnabled,
    bool? isCorrect,
    String? lastWords,
    String? currentWord,
  }) {
    return SpeakState(
      lastWords: lastWords ?? this.lastWords,
      speechEnabled: speechEnabled ?? this.speechEnabled,
      isCorrect: isCorrect ?? this.isCorrect,
      currentWord: currentWord ?? this.currentWord,
    );
  }
}

class SpeakController extends StateNotifier<SpeakState> {
  SpeakController(super.state);

  SpeechToText speechToText = SpeechToText();

  void initSpeech() async {
    bool enabled = await speechToText.initialize();
    debugPrint("speechToText is enabled: $enabled");
    state = state.copyWith(speechEnabled: enabled);

  }

  void startListening() async {
    await speechToText.listen(onResult: _onSpeechResult);
  }

  void stopListening() async {
    await speechToText.stop();
  }

  void _onSpeechResult(SpeechRecognitionResult result,) {
    debugPrint("Recognized Words: ${result.recognizedWords}");
    state = state.copyWith(
      lastWords: result.recognizedWords,
      isCorrect: result.recognizedWords == state.currentWord
    );
  }

  changeIsCorrect({required bool value}) {
    state = state.copyWith(isCorrect: value);
  }

}

final speakController = StateNotifierProvider<SpeakController, SpeakState>((ref) => SpeakController(
  SpeakState(
    lastWords: "",
    currentWord: "",
    speechEnabled: false,
    isCorrect: false,
  )
));