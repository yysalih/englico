import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeakState {
  final bool speechEnabled;
  final String lastWords;

  SpeakState({required this.speechEnabled, required this.lastWords});

  SpeakState copyWith({
    bool? speechEnabled,
    String? lastWords,
  }) {
    return SpeakState(
      lastWords: lastWords ?? this.lastWords,
      speechEnabled: speechEnabled ?? this.speechEnabled,
    );
  }
}

class SpeakController extends StateNotifier<SpeakState> {
  SpeakController(super.state);

  SpeechToText speechToText = SpeechToText();

  void initSpeech() async {
    bool enabled = await speechToText.initialize();
    state = state.copyWith(speechEnabled: enabled);

  }

  void startListening() async {
    await speechToText.listen(onResult: _onSpeechResult);
  }

  void stopListening() async {
    await speechToText.stop();
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    state = state.copyWith(lastWords: result.recognizedWords);
  }

}

final speakController = StateNotifierProvider<SpeakController, SpeakState>((ref) => SpeakController(
  SpeakState(
    lastWords: "",
    speechEnabled: false
  )
));