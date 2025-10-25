import 'package:code_pulse/providers/selected_language/selected_language_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/vs2015.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditorArea extends ConsumerWidget {
  const EditorArea({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = CodeController(
      language: ref.read(selectedLanguageProvider.notifier).getMode(),
    );

    return CodeTheme(
      data: CodeThemeData(styles: vs2015Theme),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: CodeField(controller: controller, expands: true),
      ),
    );
  }
}
