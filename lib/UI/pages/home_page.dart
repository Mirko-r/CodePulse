import 'package:code_pulse/helpers/context.dart';
import 'package:code_pulse/providers/top_bar/top_bar_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/top_bar_model.dart';
import '../widgets/blinking_outlined.dart';
import '../widgets/editor_area.dart';
import '../widgets/top_bar.dart';
import '../widgets/visualizer_area.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  double leftWidthFraction = 0.4;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(topBarStateProvider.notifier)
          .updateOffset(Offset(context.width * 0.35, 30));
    });
  }

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
            left: ref.watch(topBarStateProvider).offset.dx,
            top: ref.watch(topBarStateProvider).offset.dy,
            child: GestureDetector(
              onPanUpdate: (details) {
                ref
                    .read(topBarStateProvider.notifier)
                    .updateOffset(
                      ref.watch(topBarStateProvider).offset + details.delta,
                    );
              },
              child: TopBar(),
            ),
          ),
          if (ref.watch(topBarStateProvider).playerState == PlayerState.paused)
            Positioned.fill(child: IgnorePointer(child: BlinkingOutline())),
        ],
      ),
    );
  }
}
