import 'package:flutter/material.dart';

enum PlayerState { stopped, running, paused }

class TopBarModel {
  final Offset offset;
  final String selectedLanguage;
  final PlayerState playerState;

  const TopBarModel({
    required this.offset,
    required this.selectedLanguage,
    this.playerState = PlayerState.stopped,
  });

  TopBarModel copyWith({
    Offset? offset,
    String? selectedLanguage,
    PlayerState? playerState,
  }) {
    return TopBarModel(
      offset: offset ?? this.offset,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      playerState: playerState ?? this.playerState,
    );
  }
}
