import 'dart:async';
import 'package:code_pulse/providers/selected_language/selected_language_provider.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../model/visualizer_state.dart';
import '../../logic/simple_interpreter.dart';

part 'code_execution_provider.g.dart';

@riverpod
class CodeExecution extends _$CodeExecution {
  Timer? _timer;
  List<VisualizerState> _steps = [];

  @override
  VisualizerState build() => const VisualizerState();

  void start() {
    final code = ref.read(codeControlProvider).text;
    final language = ref.read(selectedLanguageProvider);

    // Interpret the code
    _steps = SimpleInterpreter().interpret(code, language);

    if (_steps.isNotEmpty) {
      state = _steps.first;
      _startTimer();
    } else {
      // No steps generated (empty code?), just set running
      state = const VisualizerState(running: true);
    }
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
    _steps.clear();
    _stopTimer();
  }

  void nextStep() {
    if (_steps.isEmpty) return;

    int nextIndex = state.currentStep + 1;
    if (nextIndex < _steps.length) {
      state = _steps[nextIndex];
    } else {
      pause(); // End of execution
    }
  }

  void previousStep() {
    if (_steps.isEmpty) return;

    int prevIndex = state.currentStep - 1;
    if (prevIndex >= 0) {
      state = _steps[prevIndex];
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
