import 'package:code_pulse/providers/code_execution/code_execution_provider.dart';
import 'package:code_pulse/providers/top_bar/top_bar_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/vs2015.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../model/top_bar_model.dart';
import 'line_highlight.dart';

class EditorArea extends ConsumerStatefulWidget {
  const EditorArea({super.key});

  @override
  ConsumerState<EditorArea> createState() => _EditorAreaState();
}

class _EditorAreaState extends ConsumerState<EditorArea> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(codeControlProvider);
    final execState = ref.watch(codeExecutionProvider);

    final currentLine = execState.currentStep.clamp(
      0,
      ref.read(codeControlProvider.notifier).totalLines - 1,
    );
    final textStyle = const TextStyle(
      fontFamily: 'monospace',
      fontSize: 14,
      height: 1.2, // regola l’interlinea esatta
    );

    // Calcolo altezza riga reale
    final tp = TextPainter(
      text: TextSpan(text: ' ', style: textStyle),
      textDirection: TextDirection.ltr,
    )..layout();

    final lineHeight = tp.height;

    // Scroll automatico
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;

      final targetOffset = currentLine * lineHeight;
      _scrollController.animateTo(
        targetOffset.clamp(0, _scrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
      );
    });

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          // Scrollable contenitore per CodeField
          SingleChildScrollView(
            controller: _scrollController,
            child: CodeTheme(
              data: CodeThemeData(styles: vs2015Theme),
              child: CodeField(
                controller: controller,
                expands: false,
                textStyle: textStyle,
                padding: EdgeInsets.zero,
              ),
            ),
          ),

          if (ref.watch(topBarStateProvider).playerState != PlayerState.stopped)
            // Overlay highlight riga corrente
            Positioned.fill(
              child: LineHighlightOverlay(
                currentLine: currentLine,
                textStyle: textStyle,
                horizontalPadding: 12,
                verticalOffset: tp.height * 0.9,
                highlightColor: Theme.of(
                  context,
                ).colorScheme.primary.withOpacity(0.14),
                totalLines: ref.read(codeControlProvider.notifier).totalLines,
              ),
            ),
        ],
      ),
    );
  }
}
