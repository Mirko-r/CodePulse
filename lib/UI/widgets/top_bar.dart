import 'package:code_pulse/helpers/context.dart';
import 'package:code_pulse/providers/selected_language/selected_language_provider.dart';
import 'package:code_pulse/providers/top_bar/top_bar_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/top_bar_model.dart';

class TopBar extends ConsumerWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(topBarStateProvider);
    final notifier = ref.read(topBarStateProvider.notifier);

    // Definizione unica di tutti i pulsanti
    final buttons = {
      'play': IconButton(
        icon: const Icon(Icons.play_arrow_outlined, color: Colors.green),
        onPressed: () => notifier.play(),
      ),
      'pause': IconButton(
        icon: const Icon(Icons.pause_outlined, color: Colors.orange),
        onPressed: () => notifier.pause(),
      ),
      'stop': IconButton(
        icon: const Icon(Icons.stop_outlined, color: Colors.red),
        onPressed: () => notifier.stop(),
      ),
      'back': IconButton(
        icon: const Icon(Icons.skip_previous_outlined, color: Colors.blue),
        onPressed: () => notifier.back(),
      ),
      'next': IconButton(
        icon: const Icon(Icons.skip_next_outlined, color: Colors.blue),
        onPressed: () => notifier.next(),
      ),
    };

    // Filtriamo i pulsanti in base allo stato
    List<Widget> visibleButtons;
    switch (state.playerState) {
      case PlayerState.stopped:
        visibleButtons = [buttons['play']!];
        break;
      case PlayerState.running:
        visibleButtons = [
          buttons['pause']!,
          buttons['stop']!,
          buttons['back']!,
          buttons['next']!,
        ];
        break;
      case PlayerState.paused:
        visibleButtons = [
          buttons['play']!, // resume
          buttons['stop']!,
          buttons['back']!,
          buttons['next']!,
        ];
        break;
    }

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
              value: ref.watch(selectedLanguageProvider),
              dropdownColor: context.surfaceContainerHighest,
              style: TextStyle(color: context.onSurface),
              underline: Container(),
              items: supportedLanguages
                  .map(
                    (lang) => DropdownMenuItem(value: lang, child: Text(lang)),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  ref
                      .read(selectedLanguageProvider.notifier)
                      .updateLanguage(value);
                }
              },
            ),
            const SizedBox(width: 16),
            ...visibleButtons,
          ],
        ),
      ),
    );
  }
}
