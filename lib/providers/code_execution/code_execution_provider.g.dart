// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'code_execution_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CodeExecution)
const codeExecutionProvider = CodeExecutionProvider._();

final class CodeExecutionProvider
    extends $NotifierProvider<CodeExecution, VisualizerState> {
  const CodeExecutionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'codeExecutionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$codeExecutionHash();

  @$internal
  @override
  CodeExecution create() => CodeExecution();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VisualizerState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VisualizerState>(value),
    );
  }
}

String _$codeExecutionHash() => r'2476a8de0ce5b427e783329ab24206e00d4b2274';

abstract class _$CodeExecution extends $Notifier<VisualizerState> {
  VisualizerState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<VisualizerState, VisualizerState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<VisualizerState, VisualizerState>,
              VisualizerState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(CodeControl)
const codeControlProvider = CodeControlProvider._();

final class CodeControlProvider
    extends $NotifierProvider<CodeControl, CodeController> {
  const CodeControlProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'codeControlProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$codeControlHash();

  @$internal
  @override
  CodeControl create() => CodeControl();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CodeController value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CodeController>(value),
    );
  }
}

String _$codeControlHash() => r'4b75c856cbec5ebc03e2ab0160fbfcfe58892cc8';

abstract class _$CodeControl extends $Notifier<CodeController> {
  CodeController build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<CodeController, CodeController>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CodeController, CodeController>,
              CodeController,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
