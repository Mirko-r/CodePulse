// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'top_bar_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TopBarState)
const topBarStateProvider = TopBarStateProvider._();

final class TopBarStateProvider
    extends $NotifierProvider<TopBarState, TopBarModel> {
  const TopBarStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'topBarStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$topBarStateHash();

  @$internal
  @override
  TopBarState create() => TopBarState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TopBarModel value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TopBarModel>(value),
    );
  }
}

String _$topBarStateHash() => r'bdb1b3c427ff7058d0ccc9c536774647b73013aa';

abstract class _$TopBarState extends $Notifier<TopBarModel> {
  TopBarModel build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<TopBarModel, TopBarModel>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TopBarModel, TopBarModel>,
              TopBarModel,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
