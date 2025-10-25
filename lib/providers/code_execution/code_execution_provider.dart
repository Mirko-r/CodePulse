import 'dart:async';
import 'package:code_pulse/providers/selected_language/selected_language_provider.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../model/visualizer_state.dart';

part 'code_execution_provider.g.dart';

@riverpod
class CodeExecution extends _$CodeExecution {
  Timer? _timer;

  @override
  VisualizerState build() => const VisualizerState();

  void start() {
    state = VisualizerState(running: true, paused: false, currentStep: 0);
    _startTimer();
  }

  void pause() {
    if (!state.running) return;
    state = state.copyWith(paused: true);
    _stopTimer();
  }

  void resume() {
    if (!state.running) return;
    state = state.copyWith(paused: false);
    _startTimer();
  }

  void stop() {
    state = const VisualizerState();
    _stopTimer();
  }

  void nextStep() {
    int totalLines = ref.read(codeControlProvider.notifier).totalLines;

    if (state.currentStep < totalLines - 1) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      nextStep();
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }
}

@riverpod
class CodeControl extends _$CodeControl {
  @override
  CodeController build() {
    final controller = CodeController(
      language: ref.read(selectedLanguageProvider.notifier).getMode(),
    );
    return controller;
  }

  /// Restituisce il numero totale di linee
  int get totalLines => state.text.split('\n').length;
}
