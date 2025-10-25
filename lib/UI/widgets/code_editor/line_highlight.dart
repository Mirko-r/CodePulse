import 'package:flutter/material.dart';

class LineHighlightOverlay extends StatelessWidget {
  final int currentLine;
  final TextStyle textStyle;
  final double horizontalPadding;
  final double verticalPadding;
  final Color highlightColor;
  final int totalLines;
  final double verticalOffset; // offset per compensare padding iniziale

  const LineHighlightOverlay({
    super.key,
    required this.currentLine,
    required this.textStyle,
    this.horizontalPadding = 0,
    this.verticalPadding = 0,
    this.verticalOffset = 8.0,
    required this.highlightColor,
    required this.totalLines,
  });

  @override
  Widget build(BuildContext context) {
    final tp = TextPainter(
      text: TextSpan(text: ' ', style: textStyle),
      textDirection: TextDirection.ltr,
    )..layout();

    final lineHeight = tp.height + verticalPadding;

    return IgnorePointer(
      ignoring: true,
      child: Stack(
        children: List.generate(totalLines, (index) {
          final top = index * lineHeight + verticalOffset;
          return Positioned(
            top: top,
            left: horizontalPadding,
            right: horizontalPadding,
            height: lineHeight,
            child: Container(
              color: index == currentLine ? highlightColor : Colors.transparent,
            ),
          );
        }),
      ),
    );
  }
}
