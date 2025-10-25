import 'package:code_pulse/helpers/context.dart';
import 'package:code_pulse/providers/top_bar/top_bar_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/top_bar_model.dart';
import '../widgets/blinking_outlined.dart';
import '../widgets/code_editor/editor_area.dart';
import '../widgets/top_bar.dart';
import '../widgets/code_visualizer/visualizer_area.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  double leftWidthFraction = 0.4;
  final GlobalKey _topBarKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox renderBox =
          _topBarKey.currentContext!.findRenderObject() as RenderBox;
      final barSize = renderBox.size;
      ref
          .read(topBarStateProvider.notifier)
          .updateOffset(Offset(context.width - (barSize.width + 20), 20));
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

              return Padding(
                padding: const EdgeInsets.all(18.0),
                child: Row(
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
                            if (leftWidthFraction < 0.2)
                              leftWidthFraction = 0.2;
                            if (leftWidthFraction > 0.8)
                              leftWidthFraction = 0.8;
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
                ),
              );
            },
          ),
          Positioned(
            left: ref.watch(topBarStateProvider).offset.dx,
            top: ref.watch(topBarStateProvider).offset.dy,
            child: GestureDetector(
              onPanUpdate: (details) {
                final RenderBox renderBox =
                    _topBarKey.currentContext!.findRenderObject() as RenderBox;
                final barSize = renderBox.size;

                double newDx =
                    (ref.watch(topBarStateProvider).offset.dx +
                            details.delta.dx)
                        .clamp(0.0, context.width - barSize.width);
                double newDy =
                    (ref.watch(topBarStateProvider).offset.dy +
                            details.delta.dy)
                        .clamp(0.0, context.height - barSize.height);

                ref
                    .read(topBarStateProvider.notifier)
                    .updateOffset(Offset(newDx, newDy));
              },
              child: TopBar(key: _topBarKey),
            ),
          ),
          if (ref.watch(topBarStateProvider).playerState == PlayerState.paused)
            Positioned.fill(child: IgnorePointer(child: BlinkingOutline())),
        ],
      ),
    );
  }
}
