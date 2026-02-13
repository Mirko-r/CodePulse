import 'package:highlight/highlight_core.dart';
import 'package:highlight/languages/dart.dart';
import 'package:highlight/languages/plaintext.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_language_provider.g.dart';

final List<String> supportedLanguages = ['Dart'];

@riverpod
class SelectedLanguage extends _$SelectedLanguage {
  @override
  String build() => 'Dart';

  void updateLanguage(String newLanguage) => state = newLanguage;

  Mode getMode() {
    switch (state) {
      case 'Dart':
        return dart;
      default:
        return plaintext;
    }
  }
}
