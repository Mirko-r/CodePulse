import 'package:code_pulse/helpers/context.dart';
import 'package:flutter/material.dart';

import '../widgets/editor_area.dart';
import '../widgets/top_bar.dart';
import '../widgets/visualizer_area.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double leftWidthFraction = 0.4;

  Offset topBarOffset = const Offset(50, 30);

  String selectedLanguage = 'Dart';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.surface,
      body: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;

              return Row(
                children: [
                  SizedBox(
                    width: width * leftWidthFraction,
                    child: const VisualizerArea(),
                  ),
                  MouseRegion(
                    cursor: SystemMouseCursors.resizeLeftRight,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onHorizontalDragUpdate: (details) {
                        setState(() {
                          leftWidthFraction += details.delta.dx / width;
                          if (leftWidthFraction < 0.2) leftWidthFraction = 0.2;
                          if (leftWidthFraction > 0.8) leftWidthFraction = 0.8;
                        });
                      },
                      child: Container(
                        width: 6,
                        height: context.height * 0.1,
                        decoration: BoxDecoration(
                          color: context.primary,
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  Expanded(child: const EditorArea()),
                ],
              );
            },
          ),
          Positioned(
            left: topBarOffset.dx,
            top: topBarOffset.dy,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  topBarOffset += details.delta;
                });
              },
              child: TopBar(
                selectedLanguage: selectedLanguage,
                onLanguageChanged: (lang) =>
                    setState(() => selectedLanguage = lang),
                onPlay: () {},
                onStop: () {},
                onNext: () {},
                onBack: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
