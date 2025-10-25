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
  }

  void pause() {
    state = state.copyWith(playerState: PlayerState.paused);
  }

  void stop() {
    state = state.copyWith(playerState: PlayerState.stopped);
  }

  void back() {
    // TODO
  }

  void next() {
    // TODO
  }
}
