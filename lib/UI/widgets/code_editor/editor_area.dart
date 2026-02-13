import 'dart:ui';
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
    final topBarState = ref.watch(topBarStateProvider);

    final currentLine = (execState.currentLine ?? 0).clamp(
      0,
      ref.read(codeControlProvider.notifier).totalLines - 1,
    );
    final textStyle = const TextStyle(
      fontFamily: 'monospace',
      fontSize: 14,
      height: 1.2,
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

    // Glassmorphism Card
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xff1d1f21).withOpacity(0.8),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Editor Header
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xff252526).withOpacity(0.5),
                  border: Border(
                    bottom: BorderSide(color: Colors.white.withOpacity(0.05)),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.code, color: Colors.blueAccent, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'main.dart',
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              // Editor Body
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Stack(
                    children: [
                      CodeTheme(
                        data: CodeThemeData(styles: vs2015Theme),
                        child: CodeField(
                          controller: controller,
                          expands: false,
                          textStyle: textStyle,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: Colors.transparent),
                        ),
                      ),
                      if (topBarState.playerState != PlayerState.stopped)
                        LineHighlightOverlay(
                          currentLine: currentLine,
                          textStyle: textStyle,
                          horizontalPadding: 0,
                          verticalOffset: 12.0,
                          highlightColor: Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.4),
                          totalLines: ref
                              .read(codeControlProvider.notifier)
                              .totalLines,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
