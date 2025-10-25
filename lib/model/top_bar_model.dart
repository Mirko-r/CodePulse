import 'package:flutter/material.dart';

enum PlayerState { stopped, running, paused }

class TopBarModel {
  final Offset offset;
  final PlayerState playerState;

  const TopBarModel({
    required this.offset,
    this.playerState = PlayerState.stopped,
  });

  TopBarModel copyWith({Offset? offset, PlayerState? playerState}) {
    return TopBarModel(
      offset: offset ?? this.offset,

      playerState: playerState ?? this.playerState,
    );
  }
}
