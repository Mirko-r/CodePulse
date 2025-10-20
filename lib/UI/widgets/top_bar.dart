import 'package:code_pulse/helpers/context.dart';
import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  final String selectedLanguage;
  final Function(String) onLanguageChanged;
  final VoidCallback onPlay;
  final VoidCallback onStop;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const TopBar({
    super.key,
    required this.selectedLanguage,
    required this.onLanguageChanged,
    required this.onPlay,
    required this.onStop,
    required this.onNext,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(16),
      color: context.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.drag_handle, size: 32),
            const SizedBox(width: 16),
            // DROPDOWN LINGUAGGI
            DropdownButton<String>(
              value: selectedLanguage,
              dropdownColor: context.surfaceContainerHighest,
              style: TextStyle(color: context.onSurface),
              underline: Container(),
              items: <String>['Dart', 'Python', 'Java', 'C++']
                  .map(
                    (lang) => DropdownMenuItem(value: lang, child: Text(lang)),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) onLanguageChanged(value);
              },
            ),
            const SizedBox(width: 16),

            // BOTTONI CONTROLLO
            IconButton(
              icon: const Icon(Icons.play_arrow_outlined, color: Colors.green),
              onPressed: onPlay,
            ),
            IconButton(
              icon: const Icon(Icons.stop_outlined, color: Colors.red),
              onPressed: onStop,
            ),
            IconButton(
              icon: const Icon(
                Icons.skip_previous_outlined,
                color: Colors.blue,
              ),
              onPressed: onBack,
            ),
            IconButton(
              icon: const Icon(Icons.skip_next_outlined, color: Colors.blue),
              onPressed: onNext,
            ),
          ],
        ),
      ),
    );
  }
}
