class VisualizerState {
  final bool running;
  final bool paused;
  final int currentStep;
  final int? currentLine;
  final Map<String, dynamic> variables;

  final List<String> output;

  const VisualizerState({
    this.running = false,
    this.paused = false,
    this.currentStep = 0,
    this.currentLine,
    this.variables = const {},

    this.output = const [],
  });

  VisualizerState copyWith({
    bool? running,
    bool? paused,
    int? currentStep,
    int? currentLine,
    Map<String, dynamic>? variables,

    List<String>? output,
  }) {
    return VisualizerState(
      running: running ?? this.running,
      paused: paused ?? this.paused,
      currentStep: currentStep ?? this.currentStep,
      currentLine: currentLine ?? this.currentLine,
      variables: variables ?? this.variables,

      output: output ?? this.output,
    );
  }
}
