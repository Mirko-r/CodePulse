import 'package:highlight/highlight_core.dart';
import 'package:highlight/languages/dart.dart';
import 'package:highlight/languages/plaintext.dart';
import 'package:highlight/languages/python.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_language_provider.g.dart';

final List<String> supportedLanguages = ['Dart', 'Python'];

@riverpod
class SelectedLanguage extends _$SelectedLanguage {
  @override
  String build() => 'Dart';

  void updateLanguage(String newLanguage) => state = newLanguage;

  Mode getMode() {
    switch (state) {
      case 'Dart':
        return dart;
      case 'Pithon':
        return python;
      default:
        return plaintext;
    }
  }
}
