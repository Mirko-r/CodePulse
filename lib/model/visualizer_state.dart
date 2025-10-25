class VisualizerState {
  final bool running;
  final bool paused;
  final int currentStep;

  const VisualizerState({
    this.running = false,
    this.paused = false,
    this.currentStep = 0,
  });

  VisualizerState copyWith({
    bool? running,
    bool? paused,
    int? currentStep,
    List<int>? data,
  }) {
    return VisualizerState(
      running: running ?? this.running,
      paused: paused ?? this.paused,
      currentStep: currentStep ?? this.currentStep,
    );
  }
}
