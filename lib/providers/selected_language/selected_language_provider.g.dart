// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selected_language_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SelectedLanguage)
const selectedLanguageProvider = SelectedLanguageProvider._();

final class SelectedLanguageProvider
    extends $NotifierProvider<SelectedLanguage, String> {
  const SelectedLanguageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedLanguageProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedLanguageHash();

  @$internal
  @override
  SelectedLanguage create() => SelectedLanguage();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$selectedLanguageHash() => r'fef4706a4443db988dc608fc753d1fe9bb6f980e';

abstract class _$SelectedLanguage extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
