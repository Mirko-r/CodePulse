import 'package:code_pulse/providers/code_execution/code_execution_provider.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../model/top_bar_model.dart';

part 'top_bar_provider.g.dart';

@riverpod
class TopBarState extends _$TopBarState {
  @override
  TopBarModel build() {
    return const TopBarModel(
      offset: Offset(50, 10),
      playerState: PlayerState.stopped,
    );
  }

  void updateOffset(Offset newOffset) {
    state = state.copyWith(offset: newOffset);
  }

  void play() {
    state = state.copyWith(playerState: PlayerState.running);
    // avvia anche il visualizer
    ref.read(codeExecutionProvider.notifier).start();
  }

  void pause() {
    state = state.copyWith(playerState: PlayerState.paused);
    ref.read(codeExecutionProvider.notifier).pause();
  }

  void stop() {
    state = state.copyWith(playerState: PlayerState.stopped);
    ref.read(codeExecutionProvider.notifier).stop();
  }

  void next() => ref.read(codeExecutionProvider.notifier).nextStep();

  void back() => ref.read(codeExecutionProvider.notifier).previousStep();
}
